-- General ====================================================================
vim.g.mapleader = " " -- Use `<Space>` as <Leader> key

-- Search options
vim.o.ignorecase = true
vim.o.smartcase = true

-- Displaying text
vim.o.scrolloff = 10
vim.o.wrap = false
vim.o.list = true
vim.o.listchars = "tab: ,trail:·,nbsp:␣"
vim.o.number = true
vim.o.relativenumber = true

-- Highlighting
vim.o.cursorline = true

-- Spelling
-- vim.o.spell = true

-- Multiple windows
vim.o.splitright = true
vim.o.splitbelow = true

-- Messages and info
vim.o.confirm = true
vim.o.showmode = false

-- Editing text
vim.o.showmatch = true

-- Tabs and indenting
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smartindent = true

-- Various
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
