MiniDeps.add("seblyng/roslyn.nvim")

require("roslyn").setup({})

-- Roslyn language server is installed separately. See roslyn.nvim github
-- Config below is not full, roslyn.nvim has some of it too.
vim.lsp.config("roslyn", {
    on_attach = function()
        print("This will run when the server attaches!")
    end,
    cmd = {
        "dotnet",
        "/home/mia/.local/share/roslyn-language-server/Microsoft.CodeAnalysis.LanguageServer.dll",
        "--logLevel=Information",
        "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
        "--stdio",
    },
    settings = {
        filewatch = "off",
        ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openfiles",
            dotnet_compiler_diagnostics_scope = "openfiles",
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = false,
        },
        ["csharp|completion"] = {
            dotnet_show_name_completion_suggestions = true,
            dotnet_provide_regex_completions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
        },
        ["csharp|highlighting"] = {
            dotnet_highlight_related_regex_components = true,
            dotnet_highlight_related_json_components = true,
        },
        ["csharp|inlay_hints"] = {
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = false,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = false,

            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,

            csharp_enable_inlay_hints_for_types = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = false,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_implicit_object_creation = false,
        },
        ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
        },
        ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true,
        },
        ["csharp|type_members"] = {
            dotnet_member_insertion_location = "withothermembersofthesamekind",
            dotnet_property_generation_behavior = "preferautoproperties",
        },
        ["csharp|quick_info"] = {
            dotnet_show_remarks_in_quick_info = true,
        },
    },
})
vim.lsp.enable("roslyn")

-- Lua language server is installed separately with Homebrew.
vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        ".luarc.json",
        ".luarc.jsonc",
        ".luacheckrc",
        ".stylua.toml",
        "stylua.toml",
        "selene.toml",
        "selene.yml",
        ".git",
    },
})
vim.lsp.enable("lua_ls")

local lsp_augroup = vim.api.nvim_create_augroup("LspFeatures", { clear = false })

vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_augroup,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        -- Enable inlay hints if supported
        if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true)
        end

        -- Enable code lens if supported
        if client and client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
                group = lsp_augroup,
                buffer = bufnr,
                callback = vim.lsp.codelens.refresh,
            })
        end

        -- Enable format on save if supported
        -- if client and not client:supports_method('textDocument/willSaveWaitUntil')
        --     and client:supports_method('textDocument/formatting') then
        --     vim.api.nvim_create_autocmd('BufWritePre', {
        --         group = lsp_augroup,
        --         buffer = bufnr,
        --         callback = function()
        --             vim.lsp.buf.format({
        --                 bufnr = bufnr,
        --                 id = client.id,
        --                 timeout_ms = 1000
        --             })
        --         end,
        --     })
        -- end

        -- Refresh Roslyn diagnostic on InsertLeave
        if client and client.name == "roslyn" and vim.bo[bufnr].filetype == "cs" then
            vim.api.nvim_create_autocmd("InsertLeave", {
                group = lsp_augroup,
                buffer = bufnr,
                desc = "Roslyn diagnostic refresh workaround",
                callback = function()
                    vim.lsp.util._refresh("textDocument/diagnostic", {
                        bufnr = bufnr,
                    })
                end,
            })
        end
    end,
})

vim.api.nvim_create_autocmd("LspDetach", {
    group = lsp_augroup,
    callback = function()
        -- Disable inlay hints
        vim.lsp.inlay_hint.enable(false)

        -- Disable format on save and Roslyn diagnostic refresh on InsertLeave
        -- vim.api.nvim_clear_autocmds({
        --     group = lsp_augroup,
        --     event = { 'BufWritePre', 'InsertLeave' },
        --     buffer = bufnr
        -- })
    end,
})
