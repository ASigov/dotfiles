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
local add, later = MiniDeps.add, MiniDeps.later
local now_if_args = Config.now_if_args

-- Tree-sitter ================================================================

-- Tree-sitter is a tool for fast incremental parsing. It converts text into
-- a hierarchical structure (called tree) that can be used to implement advanced
-- and/or more precise actions: syntax highlighting, textobjects, indent, etc.
--
-- Tree-sitter support is built into Neovim (see `:h treesitter`). However, it
-- requires two extra pieces that don't come with Neovim directly:
-- - Language parsers: programs that convert text into trees. Some are built-in
--   (like for Lua), 'nvim-treesitter' provides many others.
--   NOTE: It requires third party software to build and install parsers.
--   See the link for more info in "Requirements" section of the MiniMax README.
-- - Query files: definitions of how to extract information from trees in
--   a useful manner (see `:h treesitter-query`). 'nvim-treesitter' also provides
--   these, while 'nvim-treesitter-textobjects' provides the ones for Neovim
--   textobjects (see `:h text-objects`, `:h MiniAi.gen_spec.treesitter()`).
--
-- Add these plugins now if file (and not 'mini.starter') is shown after startup.
--
-- Troubleshooting:
-- - Run `:checkhealth vim.treesitter nvim-treesitter` to see potential issues.
-- - In case of errors related to queries for Neovim bundled parsers (like `lua`,
--   `vimdoc`, `markdown`, etc.), manually install them via 'nvim-treesitter'
--   with `:TSInstall <language>`. Be sure to have necessary system dependencies
--   (see MiniMax README section for software requirements).
now_if_args(function()
    add({
        source = 'nvim-treesitter/nvim-treesitter',
        -- Update tree-sitter parser after plugin is updated
        hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })
    add('nvim-treesitter/nvim-treesitter-textobjects')

    -- Display current context even if it's off screen
    add('nvim-treesitter/nvim-treesitter-context')

    -- Define languages which will have parsers installed and auto enabled
    -- After changing this, restart Neovim once to install necessary parsers. Wait
    -- for the installation to finish before opening a file for added language(s).
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
        'vimdoc',
        'xml',
        -- Add here more languages with which you want to use tree-sitter
        -- To see available languages:
        -- - Execute `:=require('nvim-treesitter').get_available()`
        -- - Visit 'SUPPORTED_LANGUAGES.md' file at
        --   https://github.com/nvim-treesitter/nvim-treesitter
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
    Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
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

    -- Neovim LSP config automatically sourced from roslyn plugin and merged with after/lsp/roslyn.lua
    --
    -- Enable roslyn language server.
    vim.lsp.enable('roslyn')

    -- Neovim LSP config automatically sourced from after/lsp/lua_ls.lua
    -- Language server specific settings are also picked up from .luarc.json
    --
    -- Enable lua language server.
    vim.lsp.enable('lua_ls')

    local on_attach = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        -- Enable code lens if supported
        if client and client:supports_method('textDocument/codeLens') then
            local refresh_codelens = function() vim.lsp.codelens.refresh() end
            refresh_codelens()
            Config.new_buf_autocmd({ 'BufEnter', 'InsertLeave' }, bufnr, refresh_codelens, 'Auto refresh CodeLens')
        end

        -- Refresh Roslyn diagnostic on InsertLeave
        if client and client.name == 'roslyn' and vim.bo[bufnr].filetype == 'cs' then
            local refresh_diagnostic = function() vim.lsp.util._refresh('textDocument/diagnostic', { bufnr = bufnr }) end
            Config.new_buf_autocmd('InsertLeave', bufnr, refresh_diagnostic, 'Auto refresh Diagnostic')
        end
    end
    Config.new_autocmd('LspAttach', '*', on_attach, 'Customize LSP features')
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
        default_format_opts = {
            -- Allow formatting from LSP server if no dedicated formatter is available
            lsp_format = 'fallback',
        },
        -- Map of filetype to formatters
        -- Make sure that necessary CLI tool is available
        formatters_by_ft = { lua = { 'stylua' } },
    })

    -- Format with conform on file save
    local conform_format = function(args) require('conform').format({ bufnr = args.buf }) end
    Config.new_autocmd('BufWritePre', '*.lua', conform_format)

    -- Custom persistent CSharpier wrapper
    local csharpier = require('utils.csharpier')

    -- Start and warm up CSharpier when opening C# and XML files
    local csharpier_warmup = function() vim.schedule(csharpier.warmup) end
    Config.new_autocmd('FileType', { 'cs', 'xml' }, csharpier_warmup)

    -- Auto-format on save for C# and XML files
    local csharpier_format = function(args) csharpier.format_and_write(args.buf) end
    Config.new_autocmd('BufWriteCmd', { '*.cs', '*.csproj', '*.props', '*.slnx' }, csharpier_format)
end)

-- Color schemes ==============================================================
MiniDeps.now(function()
    add('sainnhe/everforest')
    add('Shatur/neovim-ayu')
    add('ellisonleao/gruvbox.nvim')

    vim.cmd.colorscheme('everforest')
end)
