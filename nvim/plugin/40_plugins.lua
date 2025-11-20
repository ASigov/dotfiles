-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘
--
-- This file contains installation and configuration of plugins outside of MINI.
-- They significantly improve user experience in a way not yet possible with MINI.
-- These are mostly plugins that provide programming language specific behavior.
--
-- Use this file to install and configure other such plugins.

-- Make concise helpers for installing/adding plugins in two stages
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = _G.Config.now_if_args

-- Tree-sitter ================================================================

-- Tree-sitter is a tool for fast incremental parsing. It converts text into
-- a hierarchical structure (called tree) that can be used to implement advanced
-- and/or more precise actions: syntax highlighting, textobjects, indent, etc.
--
-- Tree-sitter support is built into Neovim (see `:h treesitter`). However, it
-- requires two extra pieces that don't come with Neovim directly:
-- - Language parsers: programs that convert text into trees. Some are built-in
--   (like for Lua), 'nvim-treesitter' provides many others.
-- - Query files: definitions of how to extract information from trees in
--   a useful manner (see `:h treesitter-query`). 'nvim-treesitter' also provides
--   these, while 'nvim-treesitter-textobjects' provides the ones for Neovim
--   textobjects (see `:h text-objects`, `:h MiniAi.gen_spec.treesitter()`).
--
-- Add these plugins now if file (and not 'mini.starter') is shown after startup.
now_if_args(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        -- Use `main` branch since `master` branch is frozen, yet still default
        checkout = 'main',
        -- Update tree-sitter parser after plugin is updated
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })
    add({
        source = 'nvim-treesitter/nvim-treesitter-textobjects',
        -- Same logic as for 'nvim-treesitter'
        checkout = 'main',
    })
    -- Display current context even if it's off screen
    add('nvim-treesitter/nvim-treesitter-context')

    -- Define languages which will have parsers installed and auto enabled
    local languages = {
        'css',
        'c_sharp',
        'diff',
        'editorconfig',
        'git_config',
        'git_rebase',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'html',
        'json',
        'liquid',
        'lua',
        'markdown',
        'regex',
        'sql',
        'toml',
        'xml',
        -- Add here more languages with which you want to use tree-sitter
        -- To see available languages:
        -- - Execute `:=require('nvim-treesitter').get_available()`
        -- - Visit 'SUPPORTED_LANGUAGES.md' file at
        --   https://github.com/nvim-treesitter/nvim-treesitter/blob/main
    }
    local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0 end
    local to_install = vim.tbl_filter(isnt_installed, languages)
    if #to_install > 0 then require('nvim-treesitter').install(to_install) end

    -- Enable tree-sitter after opening a file for a target language
    local filetypes = {}
    for _, lang in ipairs(languages) do
        for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
            table.insert(filetypes, ft)
        end
    end
    local ts_start = function(ev) vim.treesitter.start(ev.buf) end
    _G.Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
end)

-- Autoclose and autorename tags (xml, html, etc.) with treesitter
later(function()
    add('windwp/nvim-ts-autotag')

    require('nvim-ts-autotag').setup()
end)

-- Language servers ===========================================================

-- Language Server Protocol (LSP) is a set of conventions that power creation of
-- language specific tools. It requires two parts:
-- - Server - program that performs language specific computations.
-- - Client - program that asks server for computations and shows results.
--
-- Here Neovim itself is a client (see `:h vim.lsp`). Language servers need to
-- be installed separately based on your OS, CLI tools, and preferences.
-- See note about 'mason.nvim' at the bottom of the file.
--
-- Neovim's team collects commonly used configurations for most language servers
-- inside 'neovim/nvim-lspconfig' plugin.
--
-- Add it now if file (and not 'mini.starter') is shown after startup.
now_if_args(function()
    -- Provides better integration with Roslyn language server
    add('seblyng/roslyn.nvim')

    require('roslyn').setup()

    -- Configure and enable roslyn language server.
    -- LSP is installed separately (manually), see roslyn.nvim github page.
    -- Config below is not full, it will be merged with other bits from roslyn.nvim.
    vim.lsp.config('roslyn', {
        cmd = {
            'dotnet',
            '/home/mia/.local/share/roslyn-language-server/Microsoft.CodeAnalysis.LanguageServer.dll',
            '--logLevel=Information',
            '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
            '--stdio',
        },
        settings = {
            filewatch = 'off',
            ['csharp|background_analysis'] = {
                dotnet_analyzer_diagnostics_scope = 'openfiles',
                dotnet_compiler_diagnostics_scope = 'openfiles',
            },
            ['csharp|code_lens'] = {
                dotnet_enable_references_code_lens = true,
                dotnet_enable_tests_code_lens = false,
            },
            ['csharp|completion'] = {
                dotnet_show_name_completion_suggestions = true,
                dotnet_provide_regex_completions = true,
                dotnet_show_completion_items_from_unimported_namespaces = true,
            },
            ['csharp|highlighting'] = {
                dotnet_highlight_related_regex_components = true,
                dotnet_highlight_related_json_components = true,
            },
            ['csharp|inlay_hints'] = {
                dotnet_enable_inlay_hints_for_parameters = true,
                dotnet_enable_inlay_hints_for_literal_parameters = true,
                dotnet_enable_inlay_hints_for_indexer_parameters = false,
                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                dotnet_enable_inlay_hints_for_other_parameters = false,

                dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,

                csharp_enable_inlay_hints_for_types = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,
                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
            },
            ['csharp|symbol_search'] = {
                dotnet_search_reference_assemblies = true,
            },
            ['csharp|formatting'] = {
                dotnet_organize_imports_on_format = true,
            },
            ['csharp|type_members'] = {
                dotnet_member_insertion_location = 'withothermembersofthesamekind',
                dotnet_property_generation_behavior = 'preferautoproperties',
            },
            ['csharp|quick_info'] = {
                dotnet_show_remarks_in_quick_info = true,
            },
        },
    })
    vim.lsp.enable('roslyn')

    -- Configure and enable lua language server.
    -- LSP is installed separately with Homebrew.
    -- Config below is not full and will be merged with settings defined in .luarc.json
    vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = {
            '.luarc.json',
            '.luarc.jsonc',
            '.luacheckrc',
            '.stylua.toml',
            'stylua.toml',
            'selene.toml',
            'selene.yml',
            '.git',
        },
    })
    vim.lsp.enable('lua_ls')

    local on_attach = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        -- Enable code lens if supported
        if client and client:supports_method('textDocument/codeLens') then
            local refresh_codelens = function() vim.lsp.codelens.refresh() end
            refresh_codelens()
            _G.Config.new_buf_autocmd({ 'BufEnter', 'InsertLeave' }, bufnr, refresh_codelens, 'Auto refresh CodeLens')
        end

        -- Refresh Roslyn diagnostic on InsertLeave
        if client and client.name == 'roslyn' and vim.bo[bufnr].filetype == 'cs' then
            local refresh_diagnostic = function() vim.lsp.util._refresh('textDocument/diagnostic', { bufnr = bufnr }) end
            _G.Config.new_buf_autocmd('InsertLeave', bufnr, refresh_diagnostic, 'Auto refresh Diagnostic')
        end
    end
    _G.Config.new_autocmd('LspAttach', '*', on_attach, 'Customize LSP features')
    -- TODO: move this to keymaps and use leader-l keymap
    -- vim.keymap.set(
    --     'n',
    --     '<leader>h',
    --     function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
    --     { desc = 'Toggle inlay [H]ints' }
    -- )
end)

-- Formatting =================================================================

-- Programs dedicated to text formatting (a.k.a. formatters) are very useful.
-- Neovim has built-in tools for text formatting (see `:h gq` and `:h 'formatprg'`).
-- They can be used to configure external programs, but it might become tedious.
--
-- The 'stevearc/conform.nvim' plugin is a good and maintained solution for easier
-- formatting setup.
later(function()
    add('stevearc/conform.nvim')

    -- See also:
    -- - `:h Conform`
    -- - `:h conform-options`
    -- - `:h conform-formatters`
    require('conform').setup({
        -- Map of filetype to formatters
        -- Make sure that necessary CLI tool is available
        formatters_by_ft = { lua = { 'stylua' } },
    })

    -- Format with conform on file save
    local conform_format = function(args) require('conform').format({ bufnr = args.buf }) end
    _G.Config.new_autocmd('BufWritePre', '*.lua', conform_format)

    -- Custom persistent CSharpier wrapper
    local csharpier = require('utils.csharpier')

    -- Start and warm up CSharpier when opening C# and XML files
    local csharpier_warmup = function() vim.schedule(csharpier.warmup) end
    _G.Config.new_autocmd('FileType', { 'cs', 'xml' }, csharpier_warmup)

    -- Auto-format on save for C# and XML files
    local csharpier_format = function() csharpier.format_buffer() end
    _G.Config.new_autocmd('BufWritePre', { '*.cs', '*.csproj', '*.props', '*.slnx' }, csharpier_format)
end)

-- Color schemes ==============================================================
now(function()
    add('sainnhe/everforest')
    add('Shatur/neovim-ayu')
    add('ellisonleao/gruvbox.nvim')

    vim.cmd.colorscheme('everforest')
end)
