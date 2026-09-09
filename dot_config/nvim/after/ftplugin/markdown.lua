vim.opt.conceallevel = 2
vim.opt.wrap = true
vim.opt.spell = true

-- Keymap to toggle markdown preview
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { silent = true, buffer = true, desc = "Toggle markdown preview" })

-- Keymaps for obsidian.nvim
vim.keymap.set("n", "gf", function()
    if require("obsidian").util.cursor_on_markdown_link() then
        return "<cmd>ObsidianFollowLink<CR>"
    else
        return "gf"
    end
end, { noremap = false, expr = true, buffer = true, desc = "Follow link" })
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<CR>", { silent = true, buffer = true, desc = "Open in Obsidian" })
vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { silent = true, buffer = true, desc = "Search notes" })
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>", { silent = true, buffer = true, desc = "New note" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<CR>", { silent = true, buffer = true, desc = "Today's note" })



