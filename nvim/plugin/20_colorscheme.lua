MiniDeps.add("folke/tokyonight.nvim")

require("tokyonight").setup({
    transparent = false,
})

vim.cmd("colorscheme tokyonight")
