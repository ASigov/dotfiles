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
            ["@class.outer"] = "<c-v>", -- blockwise
        },
        include_surrounding_whitespace = false,
    },
})

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
