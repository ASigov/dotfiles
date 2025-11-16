MiniDeps.add("stevearc/conform.nvim")

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
    },
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.lua",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})
