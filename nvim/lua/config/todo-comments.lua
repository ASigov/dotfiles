MiniDeps.add({
    source = "folke/todo-comments.nvim",
    depends = { "nvim-lua/plenary.nvim" },
})

require("todo-comments").setup()
