require("which-key").setup {
  preset = "modern",
  icons = {
    mappings = false,
  },
}

require("which-key").add {
  { "<leader>a", group = "Harpoon" },
  { "<leader>b", group = "Buffer" },
  { "<leader>c", group = "Cursor / Config" },
  { "<leader>d", group = "Debug" },
  { "<leader>e", group = "Explorer (Oil)" },
  { "<leader>f", group = "Find / Format" },
  { "<leader>g", group = "Git" },
  { "<leader>l", group = "LeetCode" },
  { "<leader>n", group = "Notifications" },
  { "<leader>o", group = "Obsidian" },
  { "<leader>q", group = "Quit" },
  { "<leader>r", group = "LSP Refactor" },
  { "<leader>s", group = "Search / Starter" },
  { "<leader>t", group = "Toggle" },
  { "<leader>w", group = "Workspace" },
  { "<leader>x", group = "Trouble" },
  { "<leader>z", group = "Zen" },
  { "<leader>?", function() require("which-key").show() end, desc = "Which-key Cheatsheet (All Keybinds)" },
}
