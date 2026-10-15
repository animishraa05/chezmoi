-- This configuration evolves as I learn more about Nvim and become more proficient in using Nvim.
-- Since it is very long (more than 1000 lines!), you should read it carefully and take only the settings that suit you.
-- I would not recommend cloning this repo and replace your own config. Good configurations are personal,
-- built over time with a lot of polish.
--
vim.loader.enable()



local utils = require("utils")

local expected_version = "0.11.3"
utils.is_compatible_version(expected_version)

local config_dir = vim.fn.stdpath("config")
---@cast config_dir string

-- some global settings
require("globals")
-- setting options in nvim
vim.cmd("source " .. vim.fs.joinpath(config_dir, "viml_conf/options.vim"))
-- various autocommands
require("custom-autocmd")
-- all the user-defined mappings
require("mappings")
-- Custom dynamically generated cheatsheet
require("cheatsheet").setup()

-- all the plugins installed and their configurations
vim.cmd("source " .. vim.fs.joinpath(config_dir, "viml_conf/plugins.vim"))

-- diagnostic related config
require("diagnostic-conf")
require("config.dap")

-- colorscheme settings
local color_scheme = require("colorschemes")

color_scheme.colorscheme_conf["vague"]()

-- Load a random colorscheme
-- color_scheme.rand_colorscheme()

