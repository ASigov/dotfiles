-- ┌──────────────────────────┐
-- │ Built-in Neovim behavior │
-- └──────────────────────────┘
--
-- This file defines Neovim's built-in behavior. The goal is to improve overall
-- usability in a way that works best with MINI.
--
-- Here `vim.o.xxx = value` sets default value of option `xxx` to `value`.
-- See `:h 'xxx'` (replace `xxx` with actual option name).
--
-- Option values can be customized on per buffer or window basis.
-- See 'after/ftplugin/' for common example.

-- stylua: ignore start
-- The next part (until `-- stylua: ignore end`) is aligned manually for easier
-- reading. Consider preserving this or remove `-- stylua` lines to autoformat.

-- General ====================================================================
vim.g.mapleader = " " -- Use `<Space>` as <Leader> key

vim.o.undofile = true -- Enable persistent undo

-- UI =========================================================================
vim.o.breakindent    = true       -- Indent wrapped lines to match line start
vim.o.breakindentopt = "list:-1"  -- Add padding for lists (if 'wrap' is set)
vim.o.cursorline     = true       -- Enable current line highlighting
vim.o.linebreak      = true       -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.o.list           = true       -- Show helpful text indicators (see 'listchars' below)
vim.o.number         = true       -- Show line number
vim.o.pumheight      = 10         -- Make popup menu smaller
vim.o.relativenumber = true       -- Make line numbers relative
vim.o.scrolloff      = 10         -- Keep number of lines above and below cursor
vim.o.shortmess      = "CFOSWaco" -- Disable some built-in completion messages
vim.o.showmode       = false      -- Don't show mode in command line
vim.o.signcolumn     = "yes"      -- Always show signcolumn (less flicker)
vim.o.splitbelow     = true       -- Horizontal splits will be below
vim.o.splitkeep      = "screen"   -- Reduce scroll during window split
vim.o.splitright     = true       -- Vertical splits will be to the right
vim.o.winborder      = "single"   -- Use border in floating windows
vim.o.wrap           = false      -- Don't visually wrap lines (toggle with \w)

vim.o.cursorlineopt = "screenline,number" -- Show cursor line per screen line

-- Special UI symbols. More is set via 'mini.basics' later.
vim.o.fillchars = "eob: ,fold:╌"
vim.o.listchars = "extends:…,nbsp:␣,precedes:…,tab: ,trail:·"

-- Folds (see `:h fold-commands`, `:h zM`, `:h zR`, `:h zA`, `:h zj`)
vim.o.foldlevel   = 10       -- Fold nothing by default; set to 0 or 1 to fold
vim.o.foldmethod  = "indent" -- Fold based on indent level
vim.o.foldnestmax = 10       -- Limit number of fold levels
vim.o.foldtext    = ""       -- Show text under fold with its highlighting

-- Editing ====================================================================
vim.o.autoindent    = true     -- Use auto indent
vim.o.confirm       = true     -- Raise confirmation dialog instead of failing
vim.o.expandtab     = true     -- Convert tabs to spaces
vim.o.formatoptions = "rqnl1j" -- Improve commend editing
vim.o.ignorecase    = true     -- Ignore case during search
vim.o.incsearch     = true     -- Show search matches while typing
vim.o.infercase     = true     -- Infer case in built-in completion
vim.o.shiftwidth    = 4        -- Use this number of spaces for indentation
vim.o.showmatch     = true     -- Briefly jump to matching bracket if insert one
vim.o.smartcase     = true     -- Respect case if search pattern has upper case
vim.o.smartindent   = true     -- Make indenting smart
vim.o.softtabstop   = 4        -- Show tab as this number of spaces
vim.o.spell         = false    -- Disable built-in spell checking
vim.o.spelloptions  = "camel"  -- Treat camelCase word parts as separate words
vim.o.virtualedit   = "block"  -- Allow going past end of line in blockwise mod

vim.o.iskeyword = "@,48-57,_,192-255,-" -- Treat dash as `word` textobject part

-- Pattern for a start of numbered list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Built-in completion
vim.o.complete    = ".,w,b,kspell"                  -- Use less sources
vim.o.completeopt = "menuone,noselect,fuzzy,nosort" -- Use custom behavior

-- Autocommands ===============================================================

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
local f = function() vim.cmd("setlocal formatoptions-=c formatoptions-=o") end
_G.Config.new_autocmd("FileType", nil, f, "Proper 'formatoptions'")

-- There are other autocommands created by 'mini.basics'. See 'plugin/30_mini.lua'.

-- Diagnostics ================================================================

-- Neovim has built-in support for showing diagnostic messages. This configures
-- a more conservative display while still being useful.
-- See `:h vim.diagnostic` and `:h vim.diagnostic.config()`.
local diagnostic_opts = {
    -- Show all diagnostics as underline (for their messages type `<Leader>ld` or `<C-W><C-D>`)
    underline = {
        severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
        }
    },

    -- Show more details immediately for errors on the current line
    virtual_text = {
        severity = {
            min = vim.diagnostic.severity.ERROR,
            max = vim.diagnostic.severity.ERROR,
        },
        current_line = true,
        source = "if_many",
        spacing = 1,
    },
    virtual_lines = false,

    -- Show signs on top of any other sign, but only for warnings and errors
    signs = {
        severity = {
            min = vim.diagnostic.severity.WARN,
            max = vim.diagnostic.severity.ERROR,
        },
        priority = 9999,
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
    },

    float = { -- <C-W><C-D> to show diagnostic float
        source = "if_many",
        border = "single",
    },

    -- Update diagnostics only when leaving Insert mode
    update_in_insert = false,

    -- Sort diagnostics by severity
    severity_sort = true,
}

-- Use `later()` to avoid sourcing `vim.diagnostic` on startup
MiniDeps.later(function() vim.diagnostic.config(diagnostic_opts) end)
-- stylua: ignore end
