local utils = require("utils")

local plugin_dir = vim.fn.stdpath("data") .. "/lazy"
local lazypath = plugin_dir .. "/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local plugin_specs = {
  -- auto-completion engine (blink.cmp)
  {
    "saghen/blink.cmp",
    lazy = false,
    priority = 100,
    build = function() require("blink.cmp").build():pwait() end,
    dependencies = {
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
      "saghen/blink.lib",
      "saghen/blink.compat",
    },
    config = function()
      require("config.blink-cmp")
    end,
  },

  -- AI inline completions
  {
    "supermaven-inc/supermaven-nvim",
    event = "InsertEnter",
    config = function()
      require("supermaven-nvim").setup {}
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("config.codecompanion")
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      settings = {
        jsx_close_tag = {
          enable = true,
          filetypes = { "javascriptreact", "typescriptreact" },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("config.lsp")
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("config.conform")
    end,
  },
  {
    "dnlhc/glance.nvim",
    config = function()
      require("config.glance")
    end,
    event = "VeryLazy",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = true,
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    branch = "master",
    config = function()
      require("config.treesitter-textobjects")
    end,
  },
  {
    "echasnovski/mini.surround",
    version = false,
    config = function()
      require("mini.surround").setup()
    end,
  },
  {
    "echasnovski/mini.ai",
    version = false,
    config = function()
      require("mini.ai").setup()
    end,
  },

  -- Show match number and index for searching
  {
    "kevinhwang91/nvim-hlslens",
    branch = "main",
    keys = { "*", "#", "n", "N" },
    config = function()
      require("config.hlslens")
    end,
  },

  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    cmd = {
      "ObsidianOpen",
      "ObsidianNew",
      "ObsidianSearch",
      "ObsidianToday",
      "ObsidianQuickSwitch",
      "ObsidianTags",
    },
    event = {
      "BufReadPre /home/ani/blog/content/**.md",
      "BufNewFile /home/ani/blog/content/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "/home/ani/blog/content",
        },
      },
      daily_notes = {
        folder = "Private/Daily",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        template = "template.md",
      },
      templates = {
        folder = "Private/templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    opts = {},
  },
  {
    "blackhat-7/vellum.nvim",
    ft = "markdown",
    keys = {
      { "<leader>mp", "<cmd>Vellum<cr>", desc = "Markdown preview" },
      { "<leader>mz", function() require("vellum").zoom() end, desc = "Vellum zoom" },
    },
    opts = {},
  },
  {
    "dkarter/bullets.vim",
    ft = { "markdown" },
    init = function()
      vim.g.bullets_enabled_file_types = { "markdown" }
    end,
  },
  -- Colorschemes
  { "vague-theme/vague.nvim", lazy = true },
  { "sainnhe/gruvbox-material", lazy = true },
  { "sainnhe/everforest", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "folke/tokyonight.nvim", lazy = true },

  -- nerdfont icons
  {
    "echasnovski/mini.icons",
    version = false,
    config = function()
      require("mini.icons").mock_nvim_web_devicons()
      require("mini.icons").tweak_lsp_kind()
    end,
    lazy = true,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "BufRead",
    config = function()
      require("config.lualine")
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = { "BufEnter" },
    config = function()
      require("config.bufferline")
    end,
  },

  -- fancy start screen



  {
    "luukvbaal/statuscol.nvim",
    opts = {},
    config = function()
      require("config.nvim-statuscol")
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VeryLazy",
    opts = {},
    init = function()
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function()
      require("config.nvim_ufo")
    end,
  },



  { "nvim-lua/plenary.nvim", lazy = true },

  -- Automatic insertion and deletion of a pair of characters
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },



  -- Manage your yank history
  {
    "gbprod/yanky.nvim",
    config = function()
      require("config.yanky")
    end,
    cmd = "YankyRingHistory",
  },







  -- Git command inside vim
  {
    "tpope/vim-fugitive",
    event = "User InGitRepo",
    config = function()
      require("config.fugitive")
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("config.git-conflict")
    end,
  },

  -- Show git change signs in vim sign column
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config.gitsigns")
    end,
    event = "BufRead",
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen" },
  },



  -- Seamless navigation between tmux and nvim
  {
    "christoomey/vim-tmux-navigator",
    enabled = function()
      return utils.executable("tmux")
    end,
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
  },

  -- Modern matchit implementation
  { "andymass/vim-matchup", event = "BufRead" },



  -- showing keybindings
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("config.which-key")
    end,
  },


  -- Lightning-fast navigation
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- Beautiful diagnostics panel
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
    },
  },

  -- Highlight and search TODO comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufRead",
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO" },
      { "<leader>st", "<cmd>TodoTrouble<cr>", desc = "Search TODOs" },
    },
  },

  -- Move lines and selections
  {
    "echasnovski/mini.move",
    version = false,
    config = function()
      require("mini.move").setup({
        mappings = {
          left  = '<A-h>',
          right = '<A-l>',
          down  = '<A-j>',
          up    = '<A-k>',
          line_left  = '<A-h>',
          line_right = '<A-l>',
          line_down  = '<A-j>',
          line_up    = '<A-k>',
        },
      })
    end,
  },

  -- file explorer
  {
    "stevearc/oil.nvim",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      require("config.oil")
    end,
  },

  {
    "j-hui/fidget.nvim",
    event = "BufRead",
    config = function()
      require("config.fidget-nvim")
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {},
  },
  {
    'nvim-java/nvim-java',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      require('java').setup()
    end,
    lazy = true,
    ft = { "java" },
  },

  {
    'williamboman/mason.nvim',
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      require("config.mason")
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
  },

  {
    "kawre/leetcode.nvim",
    build = ":TSUpdateSync",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lang = "cpp",
      storage = { home = vim.fn.expand("~") .. "/leetcode" },
      image_support = false,
      console = { open_on_runcode = false },
    },
  },

  { "tpope/vim-dadbod", lazy = true },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = { "tpope/vim-dadbod" },
    cmd = { "DBUI" },
    init = function()
      vim.g.db_ui_save_location = vim.fn.expand("~") .. "/.config/nvim/db_ui_queries"
    end,
  },

  -- Discord Rich Presence
  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    event = "VeryLazy",
    opts = {
      usercmds = true,
      editor = {
        client = "neovim",
        tooltip = "The Superior Text Editor",
      },
      display = {
        show_time = true,
        show_repository = true,
      },
      lsp = {
        show_problem_count = true,
        severity = 1, -- only errors
      },
      idle = {
        enabled = true,
        timeout = 300000, -- 5 minutes
        text = "Idling",
      },
      text = {
        viewing = "Viewing {}",
        editing = "Editing {}",
        file_browser = "Browsing files in {}",
        plugin_manager = "Managing plugins",
        lsp_manager = "Configuring LSP",
        vcs = "Committing changes in {}",
        workspace = "In {}",
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "echasnovski/mini.icons" },
    opts = {},
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>FzfLua help_tags<cr>", desc = "Help Tags" },
      { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps Cheatsheet" },
    },
  },
  {
    -- oil.nvim is the default dashboard now (see lua/custom-autocmd.lua).
    -- mini.starter stays available as a manually-opened palette (<leader>ss).
    "echasnovski/mini.starter",
    version = false,
    init = function()
      vim.g.ministarter_disable_autostart = true
    end,
    opts = {},
    keys = {
      {
        "<leader>ss",
        function()
          require("mini.starter").open()
        end,
        desc = "open mini.starter palette",
      },
    },
  },
}

---@diagnostic disable-next-line: missing-fields
require("lazy").setup {
  spec = plugin_specs,
  ui = {
    border = "rounded",
    title = "Plugin Manager",
    title_pos = "center",
  },
  rocks = {
    enabled = false,
    hererocks = false,
  },
}
