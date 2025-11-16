require("mini.notify").setup()
vim.notify = require("mini.notify").make_notify()

require("mini.icons").setup()
require("mini.diff").setup()
require("mini.statusline").setup()
require("mini.pairs").setup()
require("mini.surround").setup()

vim.keymap.set("n", "<leader>d", function()
    MiniDiff.toggle_overlay(vim.api.nvim_get_current_buf())
end, { desc = "Toggle [D]iff overlay" })
