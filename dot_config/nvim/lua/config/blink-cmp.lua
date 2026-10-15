require("blink.cmp").setup {
  keymap = {
    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-n>"] = { "select_next", "fallback_to_mappings" },
    ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
    ["<C-y>"] = { "select_and_accept", "fallback" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
  },

  appearance = {
    nerd_font_variant = "mono",
  },

  completion = {
    trigger = { show_on_insert = true },
    documentation = {
      auto_show = true,
      window = {
        border = "single",
        max_width = 100,
        max_height = 30,
      },
    },
    ghost_text = { enabled = true },
    menu = {
      border = "single",
      draw = {
        columns = {
          { "kind_icon" },
          { "label", "label_description", gap = 1 },
          { "source_name" },
        },
      },
    },
  },

  signature = {
    enabled = true,
    window = { show_documentation = true },
  },

  sources = {
    default = { "lsp", "path", "buffer", "snippets" },
    per_filetype = {
      sql = { "lsp", "path", "buffer", "snippets", "dadbod" },
      markdown = { "obsidian", "obsidian_new", "obsidian_tags", "lsp", "path", "buffer", "snippets" },
    },
    min_keyword_length = function(ctx)
      if vim.tbl_contains({ "markdown", "text" }, vim.bo.filetype) then
        return 3
      end
      return 0
    end,
    providers = {
      dadbod = {
        name = "Dadbod",
        module = "custom.blink-dadbod",
        enabled = function() return vim.bo.filetype == "sql" end,
      },
      obsidian = {
        name = "obsidian",
        module = "blink.compat.source",
      },
      obsidian_new = {
        name = "obsidian_new",
        module = "blink.compat.source",
      },
      obsidian_tags = {
        name = "obsidian_tags",
        module = "blink.compat.source",
      },
      buffer = {
        max_items = 5,
      },
    },
  },

  snippets = { preset = "luasnip" },

  fuzzy = { implementation = "prefer_rust_with_warning" },

  cmdline = {
    completion = {
      menu = { auto_show = true },
    },
    keymap = {
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-y>"] = { "select_and_accept", "fallback" },
      ["<C-e>"] = { "cancel", "fallback" },
    },
    sources = {
      default = function()
        local type = vim.fn.getcmdtype()
        if type == "/" or type == "?" then
          return { "buffer" }
        end
        return { "path", "cmdline" }
      end,
    },
  },
}
