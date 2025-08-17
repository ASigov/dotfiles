-- Configure :make to act as dotnet CLI
-- For example command `:make run` is equivalent to running `dotnet run`
vim.o.makeprg = "dotnet"

vim.treesitter.start()
