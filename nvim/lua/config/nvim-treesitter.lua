-- tree-sitter-cli installed via:
--     brew install tree-sitter-cli
-- External CLI is only required to compile external grammars.
MiniDeps.add({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "main",
    hooks = {
        post_checkout = function()
            vim.cmd("TSUpdate")
        end,
    },
})
MiniDeps.add({
    source = "nvim-treesitter/nvim-treesitter-textobjects",
    checkout = "main",
})
MiniDeps.add("nvim-treesitter/nvim-treesitter-context")
MiniDeps.add("windwp/nvim-ts-autotag")

require("nvim-treesitter").install({
    "css",
    "c_sharp",
    "diff",
    "editorconfig",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "html",
    "json",
    "liquid",
    "lua",
    "markdown",
    "regex",
    "sql",
    "toml",
    "xml",
})
require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
        selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "V", -- linewise
        },
        include_surrounding_whitespace = false,
    },
})
require("nvim-ts-autotag").setup()

vim.keymap.set({ "x", "o" }, "af", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "if", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)

vim.keymap.set("n", "<A-l>", function()
    require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
end)
vim.keymap.set("n", "<A-h>", function()
    require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
end)
vim.keymap.set("n", "<A-j>", function()
    require("nvim-treesitter-textobjects.swap").swap_next("@function.outer")
end)
vim.keymap.set("n", "<A-k>", function()
    require("nvim-treesitter-textobjects.swap").swap_previous("@function.outer")
end)

-- vim.keymap.set("n", "<C-l>", function()
--     require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects")
-- end)
-- vim.keymap.set("n", "<C-h>", function()
--     require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects")
-- end)
-- vim.keymap.set("n", "<C-j>", function()
--     require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
-- end)
-- vim.keymap.set("n", "<C-k>", function()
--     require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
-- end)
