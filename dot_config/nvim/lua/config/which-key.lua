require("which-key").setup {
  preset = "modern",
  icons = {
    mappings = false,
  },
}

require("which-key").add {
  { "<leader>a", group = "Harpoon" },
  { "<leader>b", group = "Buffer" },
  { "<leader>c", group = "Cursor" },
  { "<leader>d", group = "Debug" },
  { "<leader>e", group = "Edit Config" },
  { "<leader>f", group = "Format" },
  { "<leader>g", group = "Git" },
  { "<leader>l", group = "LeetCode" },
  { "<leader>n", group = "Notifications" },
  { "<leader>o", group = "Obsidian" },
  { "<leader>q", group = "Quit" },
  { "<leader>r", group = "LSP Refactor" },
  { "<leader>s", group = "Search" },
  { "<leader>t", group = "Toggle" },
  { "<leader>w", group = "Workspace" },
  { "<leader>x", group = "Trouble" },
  { "<leader>z", group = "Zen" },
}
