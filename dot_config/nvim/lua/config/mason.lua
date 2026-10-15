require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "ruff", "lua_ls", "clangd", "marksman" },
})

local capabilities = require("lsp_utils").get_default_capabilities()

-- Set global capabilities for all servers
vim.lsp.config("*", { capabilities = capabilities })

-- Enable servers (they will pick up config from after/lsp/*.lua)
vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")
vim.lsp.enable("marksman")
