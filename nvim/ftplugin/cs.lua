-- Configure :make to act as dotnet CLI
-- For example command `:make run` is equivalent to running `dotnet run`
vim.o.makeprg = "dotnet"

vim.treesitter.start()

-- Start background persistent CSharpier process when opening cs file
-- and warm it up to be ready to format on save or :FormatCSharp
local csharpier = require("utils.csharpier")
vim.defer_fn(csharpier.warmup, 100)
