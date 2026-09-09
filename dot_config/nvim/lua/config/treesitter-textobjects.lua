require("nvim-treesitter.configs").setup {
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        ["aa"] = { query = "@parameter.outer", desc = "parameter outer" },
        ["ia"] = { query = "@parameter.inner", desc = "parameter inner" },
      },
      selection_modes = {
        ["@function.inner"] = "V",
        ["@function.outer"] = "V",
        ["@class.outer"] = "V",
        ["@class.inner"] = "V",
        ["@parameter.outer"] = "v",
      },
      include_surrounding_whitespace = false,
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
        ["]a"] = "@parameter.inner",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
        ["[a"] = "@parameter.inner",
      },
    },
  },
}
