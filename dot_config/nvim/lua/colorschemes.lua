--- This module will load a random colorscheme on nvim startup process.
local utils = require("utils")

local M = {}

-- Colorscheme to its directory name mapping, because colorscheme repo name is not necessarily
-- the same as the colorscheme name itself.
M.colorscheme_conf = {
  kanagawa = function()
    vim.cmd("colorscheme kanagawa-dragon")
  end,
  gruvbox_material = function()
    vim.g.gruvbox_material_foreground = "original"
    vim.g.gruvbox_material_background = "hard"
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_better_performance = 1
    vim.cmd([[colorscheme gruvbox-material]])
  end,
  everforest = function()
    vim.g.everforest_background = "hard"
    vim.g.everforest_enable_italic = 1
    vim.g.everforest_better_performance = 1
    vim.cmd([[colorscheme everforest]])
  end,
  tokyonight = function()
    vim.cmd([[colorscheme tokyonight]])
  end,
  catppuccin = function()
    require("catppuccin").setup()
    vim.cmd.colorscheme("catppuccin")
  end,
  vague = function()
    require('vague').setup({
      transparent = false, -- If true, background is not set
      bold = true, -- Disable bold globally
      italic = true, -- Disable italic globally
      on_highlights = function(hl, colors) end,
      colors = {
        bg = '#141415',
        inactiveBg = '#1c1c24',
        fg = '#cdcdcd',
        floatBorder = '#878787',
        line = '#252530',
        comment = '#606079',
        builtin = '#b4d4cf',
        func = '#c48282',
        string = '#e8b589',
        number = '#e0a363',
        property = '#c3c3d5',
        constant = '#aeaed1',
        parameter = '#bb9dbd',
        visual = '#333738',
        error = '#d8647e',
        warning = '#f3be7c',
        hint = '#7e98e8',
        operator = '#90a0b5',
        keyword = '#6e94b2',
        type = '#9bb4bc',
        search = '#405065',
        plus = '#7fa563',
        delta = '#f3be7c',
      },
    })
    vim.cmd.colorscheme('vague')
  end,
}

--- Use a random colorscheme from the pre-defined list of colorschemes.
M.rand_colorscheme = function()
  local colorscheme = utils.rand_element(vim.tbl_keys(M.colorscheme_conf))

  -- Load the colorscheme and its settings
  M.colorscheme_conf[colorscheme]()
end

return M
