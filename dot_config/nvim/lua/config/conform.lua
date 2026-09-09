require("conform").setup {
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
    cpp = { "clang_format" },
    c = { "clang_format" },
    python = { "ruff_format", "ruff_organize_imports" },
  },

  format_on_save = {
    lsp_fallback = true,
    timeout_ms = 1000,
  },
}
