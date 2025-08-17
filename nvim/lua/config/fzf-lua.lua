MiniDeps.add("ibhagwan/fzf-lua")

require("fzf-lua").setup({
    file_icon_padding = " ",
})

vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua buffers<CR>", { desc = "[P]ick [B]uffers" })
vim.keymap.set("n", "<leader>pf", "<cmd>FzfLua files<CR>", { desc = "[P]ick [F]iles" })
vim.keymap.set("n", "<leader>pg", "<cmd>FzfLua live_grep<CR>", { desc = "[P]ick [G]rep" })
vim.keymap.set("n", "<leader>ph", "<cmd>FzfLua helptags<CR>", { desc = "[P]ick [H]elptags" })
vim.keymap.set("n", "<leader>pk", "<cmd>FzfLua keymaps<CR>", { desc = "[P]ick [K]eymaps" })
vim.keymap.set("n", "<leader>pc", "<cmd>FzfLua commands<CR>", { desc = "[P]ick [C]ommands" })
vim.keymap.set("n", "<leader>pn", "<cmd>FzfLua files cwd=~/.config/nvim<CR>", { desc = "[P]ick [N]vim config files" })
