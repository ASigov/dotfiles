local group = vim.api.nvim_create_augroup("MyLuaConfigGroup", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.hl.on_yank()
    end,
})
