-- ├ init.lua          Initial (this) file executed during startup
-- ├ plugin/           Files automatically sourced during startup
-- ├── 10_options.lua  Built-in Neovim behavior
-- ├── 20_keymaps.lua  Custom mappings
-- ├── 30_mini.lua     MINI configuration
-- ├── 40_plugins.lua  Plugins outside of MINI
-- ├ snippets/         User defined snippets (has demo file)
-- ├ after/            Files to override behavior added by plugins
-- ├── ftplugin/       Files for filetype behavior (has demo file)
-- ├── lsp/            Language server configurations (has demo file)
-- ├── snippets/       Higher priority snippet files (has demo file)

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
