MiniDeps.add("ibhagwan/fzf-lua")

require("fzf-lua").setup({
    file_icon_padding = " ",
})

vim.keymap.set("n", "<leader>b", "<cmd>FzfLua buffers<CR>", { desc = "Pick [B]uffers" })
vim.keymap.set("n", "<leader>f", "<cmd>FzfLua files<CR>", { desc = "Pick [F]iles" })
vim.keymap.set("n", "<leader>r", "<cmd>FzfLua live_grep<CR>", { desc = "Pick G[R]ep" })
vim.keymap.set("n", "<leader>c", "<cmd>FzfLua files cwd=~/.config/nvim<CR>", { desc = "Pick Nvim [C]onfig files" })
vim.keymap.set("n", "<leader>g", "<cmd>FzfLua git_status<CR>", { desc = "Pick [G]it Status" })
