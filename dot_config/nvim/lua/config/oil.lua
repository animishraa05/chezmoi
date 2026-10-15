require("oil").setup({
  default_file_explorer = true,
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = true,
  cleanup_delay_ms = 2000,
  lsp_file_methods = {
    enabled = true,
    timeout_ms = 1000,
    autosave_changes = false,
  },
  constrain_cursor = "editable",
  watch_for_changes = true,
  columns = {
    "icon",
  },
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
    ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
    ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open in new tab" },
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-r>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to current directory" },
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
  use_default_keymaps = true,
  view_options = {
    show_hidden = false,
    is_hidden_file = function(name, bufnr)
      return vim.startswith(name, ".")
    end,
    -- Prevent "oil:" artifact directory from ever showing up
    is_always_hidden = function(name, bufnr)
      return name == ".." or name == ".git" or name == "oil:" or vim.startswith(name, "oil:")
    end,
    natural_order = true,
    case_insensitive = false,
    sort = {
      { "type", "asc" },
      { "name", "asc" },
    },
    highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
      return nil
    end,
  },
  float = {
    padding = 2,
    max_width = 100,
    max_height = 32,
    border = "rounded",
    win_options = {
      winblend = 0,
    },
    override = function(conf)
      return conf
    end,
  },
  preview_win = {
    update_on_cursor_moved = true,
    preview_method = "fast_scratch",
    disable_on_touch = false,
    win_options = {
      winblend = 0,
    },
  },
  progress = {
    max_width = 0.9,
    min_width = { 40, 0.4 },
    width = nil,
    max_height = { 10, 0.9 },
    min_height = { 5, 0.1 },
    height = nil,
    border = "rounded",
    minimized_border = "none",
    win_options = {
      winblend = 0,
    },
  },
  win_options = {
    wrap = false,
    signcolumn = "yes:1",
    cursorcolumn = false,
    foldcolumn = "0",
    spell = false,
    list = false,
    conceallevel = 3,
    concealcursor = "nvic",
  },
})
