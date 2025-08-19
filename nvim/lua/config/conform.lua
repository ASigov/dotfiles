MiniDeps.add("stevearc/conform.nvim")

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
    },
    format_on_save = {}, -- enable but use defaults
})
