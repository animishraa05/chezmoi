require("oil").setup({
  default_file_explorer = true,
  columns = { "icon" },
  view_options = {
    show_hidden = true,
    natural_order = true,
    sort = { { "type", "asc" }, { "name", "asc" } },
  },
  win_options = {
    signcolumn = "yes:1",
  },
})
