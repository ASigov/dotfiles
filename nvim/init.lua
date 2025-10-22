-- Bootstrap 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local mini_path = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local origin = "https://github.com/nvim-mini/mini.nvim"
    local clone_cmd = { "git", "clone", "--filter=blob:none", origin, mini_path }
    vim.fn.system(clone_cmd)
    vim.cmd("packadd mini.nvim | helptags ALL")
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Plugin manager. Set up immediately for `now()`/`later()` helpers.
-- Example usage:
-- - `MiniDeps.add('...')` - use inside config to add a plugin
-- - `:DepsUpdate` - update all plugins
-- - `:DepsSnapSave` - save a snapshot of currently active plugins
--
-- See also:
-- - `:h MiniDeps-overview` - how to use it
-- - `:h MiniDeps-commands` - all available commands
-- - 'plugin/30_mini.lua' - more details about 'mini.nvim' in general
require("mini.deps").setup()

vim.g.mapleader = " "

require("config.options")
require("config.colorscheme")
require("config.keymaps")
require("config.autocommands")
require("config.mini")
require("config.fzf-lua")
require("config.blink")
require("config.lsp")
require("config.csharpier")
require("config.conform")
require("config.diagnostics")
require("config.nvim-treesitter")
require("config.todo-comments")
