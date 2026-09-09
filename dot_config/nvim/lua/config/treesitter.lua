require("nvim-treesitter.configs").setup {
  ensure_installed = { "python", "cpp", "java", "lua", "vim", "json", "toml", "markdown", "markdown_inline", "html", "css", "javascript", "typescript", "tsx", "regex", "bash" },
  ignore_install = {},
  highlight = {
    enable = true,
    disable = { "help" },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      node_incremental = "<CR>",
      scope_incremental = "<S-CR>",
      node_decremental = "<BS>",
    },
  },
  indent = { enable = true },
}
