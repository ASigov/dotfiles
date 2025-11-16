vim.treesitter.start()

-- Start background persistent CSharpier process when opening xml file
-- and warm it up to be ready to format on save or :FormatCSharp
local csharpier = require("utils.csharpier")
vim.defer_fn(csharpier.warmup, 100)
