MiniDeps.add("stevearc/conform.nvim")

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        -- TODO: cs formatter
    },
    format_on_save = {
        lsp_fallback = false,
        timeout_ms = 1000,
    },
})
