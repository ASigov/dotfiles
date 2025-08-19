local csharpier = require("utils.csharpier")

-- Command to format current buffer
vim.api.nvim_create_user_command("FormatCSharp", function()
    csharpier.format_buffer()
end, {})

-- Auto-format on save for .cs
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.cs",
    callback = function()
        csharpier.format_buffer()
    end,
})
