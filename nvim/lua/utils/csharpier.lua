local uv = vim.uv
local M = {}

local handle, stdin, stdout, stderr
local stdout_buffer = ''
local pending = {}
local etx = string.char(3)

function M.start_server()
    if handle then return end

    stdin = uv.new_pipe()
    stdout = uv.new_pipe()
    stderr = uv.new_pipe()

    handle = uv.spawn('csharpier', {
        args = { 'pipe-files' },
        stdio = { stdin, stdout, stderr },
    }, function(code, signal)
        vim.schedule(
            function()
                vim.notify(string.format('[CSharpier] exited (code %d, signal %d)', code, signal), vim.log.levels.WARN)
            end
        )
        M.stop_server()
    end)

    -- stdout reader
    uv.read_start(stdout, function(err, data)
        assert(not err, err)
        if data then
            stdout_buffer = stdout_buffer .. data
            while true do
                local pos = stdout_buffer:find(etx, 1, true)
                if not pos then break end
                local formatted = stdout_buffer:sub(1, pos - 1)
                stdout_buffer = stdout_buffer:sub(pos + 1)
                local cb = table.remove(pending, 1)
                if cb then vim.schedule(function() cb(nil, formatted) end) end
            end
        end
    end)

    -- stderr reader
    uv.read_start(stderr, function(err, data)
        assert(not err, err)
        if data and #data > 0 then
            vim.schedule(function() vim.notify('[CSharpier stderr] ' .. data, vim.log.levels.ERROR) end)
        end
    end)

    vim.notify('[CSharpier] server started', vim.log.levels.INFO)
end

function M.stop_server()
    if stdout and not uv.is_closing(stdout) then stdout:close() end
    if stderr and not uv.is_closing(stderr) then stderr:close() end
    if stdin and not uv.is_closing(stdin) then stdin:close() end
    if handle and not uv.is_closing(handle) then handle:close() end
    handle, stdin, stdout, stderr = nil, nil, nil, nil
    stdout_buffer, pending = '', {}
end

--- Format a buffer via the persistent CSharpier
---@param bufnr integer|nil
function M.format_buffer(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local content = table.concat(lines, '\n')

    table.insert(pending, function(err, formatted)
        if err then
            vim.notify('[CSharpier] ' .. err, vim.log.levels.ERROR)
            return
        end
        local new_lines = vim.split(formatted, '\n', { plain = true })
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
    end)

    local payload = filepath .. etx .. content .. etx
    uv.write(stdin, payload)
end

--- Format a string of code via the persistent CSharpier
---@param filepath string
---@param content string
---@param callback fun(err: string|nil, formatted?: string)
function M.format_string(filepath, content, callback)
    M.start_server() -- no-op if already running

    table.insert(pending, function(err, formatted)
        if callback then callback(err, formatted) end
    end)

    local payload = filepath .. etx .. content .. etx
    uv.write(stdin, payload)
end

function M.warmup()
    -- Send two "files" one by one to warmup CSharpier
    local dummy_file = 'Hello.cs'
    local dummy_content = 'public class Hello { }'
    M.format_string(dummy_file, dummy_content, function(err, _)
        if err then
            vim.notify('[CSharpier] warmup ' .. err, vim.log.levels.ERROR)
            return
        end

        dummy_file = 'World.cs'
        dummy_content = 'public class World { }'
        M.format_string(dummy_file, dummy_content, function(err2, _)
            if err2 then
                vim.notify('[CSharpier] warmup ' .. err2, vim.log.levels.ERROR)
                return
            end
        end)
    end)
end

return M
