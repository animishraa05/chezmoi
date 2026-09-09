# Neovim Plugin Guide — Complete Reference

## Keybinding Notation Primer

| Notation | Meaning |
|----------|---------|
| `<leader>` | The `,` key (set in `globals.lua`) |
| `<CR>` | Enter / Return |
| `<C-...>` | Hold Ctrl + key (e.g. `<C-n>` = Ctrl+n) |
| `<S-...>` | Hold Shift + key |
| `<A-...>` | Hold Alt (or Option on Mac) + key |
| `<M-...>` | Same as Alt |
| `<space>` | The Space bar |
| `nmap` | Normal mode mapping |
| `imap` | Insert mode mapping |
| `xmap` | Visual mode mapping |
| `vmap` | Visual mode mapping |
| `tmap` | Terminal mode mapping |
| `{ "n", "x" }` | Mapping works in both Normal and Visual modes |
| `desc = "..."` | Description shown by which-key when you pause |

---

## 1. Plugin Manager — lazy.nvim

**What it does**: Installs and manages all other plugins. The single source of truth is `lua/plugin_specs.lua`. Run these commands (type `:` first in normal mode):

| Command | Alias | What it does |
|---------|-------|-------------|
| `:Lazy install` | `:pi` | Install missing plugins |
| `:Lazy update` | `:pud` | Update all plugins |
| `:Lazy clean` | `:pc` | Remove unused plugins |
| `:Lazy sync` | `:ps` | Install + clean in one go |

---

## 2. Core UX Plugins

### which-key.nvim
**What**: Shows a popup with available keybindings after you press `<leader>` (`,`).
- Pause after pressing `<leader>` (`,`) or any waiting-for-input key — a menu appears.
- Press the next key shown in the menu to trigger the action.

### lualine.nvim — Status Line
**What**: The bar at the bottom of each window. Shows (left to right):
- Filename (with 🔒 if read-only)
- Git branch (truncated to 20 chars)
- Git ahead/behind count (e.g. `↑[3] ↓[2]`)
- Git diff (+ added, ~ modified, - removed)
- Python virtual env / Conda env name
- Session name (`%S`)
- `[SPELL]` if spell check is on
- Active LSP server name (e.g. `pyright`, `clangd`, `jdtls`) — shows 📡 if none
- Diagnostics (🆇 error, ⚠️ warn, ℹ️ info,  hint)
- Trailing whitespace warning
- Mixed indentation warning
- File encoding (e.g. `UTF-8`)
- File format (unix/win/mac)
- Filetype
- IME indicator `[CN]` (macOS only)
- Cursor position (line, col) + progress %

### bufferline.nvim — Buffer Tabs
**What**: Shows open buffers as a tab line at the top. Think browser tabs.

| Key | What it does |
|-----|-------------|
| `<space>bp` | Pick a buffer from a visual list |
| `:bdelete<N>` | Close buffer number N |
| `:bnext` or `:bn` | Go to next buffer |
| `:bprevious` or `:bp` | Go to previous buffer |
| Click on tab | Switch to that buffer |
| Right-click on tab | Close that buffer |

### dashboard-nvim — Start Screen
**What**: The fancy screen you see when you open Neovim with no file.

| Key | What it does |
|-----|-------------|
| `, f f` | Find files (opens Snacks picker) |
| `, f r` | Recently opened files |
| `, f g` | Live grep (search text in project) |
| `, e v` | Open your init.lua config |
| `e` | New empty file |
| `q` | Quit Neovim |

### nvim-notify
**What**: Replaces the default `vim.notify()` with prettier animated notifications. Messages fade in and slide out.

### fidget.nvim
**What**: Shows a small spinner/status in the corner when LSP servers are starting or working. No config needed — it just works.

### statuscol.nvim
**What**: Replaces the default line-number column with a customizable one containing:
- Sign column (for git changes, diagnostics, etc.)
- Line number
- Fold column (shows `-` or `+` for foldable lines)

### mini.icons
**What**: Provides file-type icons (nerd font icons) used by lualine, nvim-cmp, oil, etc.

---

## 3. Editing Plugins

### vim-commentary
**What**: Comment/uncomment lines with `gc`.

| Key | Mode | What it does |
|-----|------|-------------|
| `gcc` | Normal | Comment/uncomment current line |
| `gc` + motion | Normal | Comment/uncomment the region you move through |
| `gc` | Visual | Comment/uncomment the selected lines |

Example: `gcap` = comment out the current paragraph.

### vim-sandwich — Surround
**What**: Add, delete, or change surrounding characters (quotes, brackets, tags).

| Key | Mode | What it does |
|-----|------|-------------|
| `sa` (then `motion` then `char`) | Normal | **S**urround **A**dd — e.g. `saiw"` adds `"` around the inner word |
| `sd` (then `char`) | Normal | **S**urround **D**elete — e.g. `sd"` deletes `"` around cursor |
| `sr` (then `old-char` then `new-char`) | Normal | **S**urround **R**eplace — e.g. `sr"'` changes `"hello"` to `'hello'` |

### targets.vim
**What**: Adds more text objects like `i,` (inside comma), `a,` (around comma), `in` (inside next), `il` (inside last). Makes `ci,` (change inside commas), `da,` (delete around arg), etc. work on arguments in function calls.

### vim-matchup
**What**: Improved `%` key — jumps between matching `( )`, `{ }`, `[ ]`, `if/end`, `begin/end`, HTML tags, etc. Also highlights the match and can show off-screen matches in a popup.

| Key | What it does |
|-----|-------------|
| `%` | Jump between matching pair |
| `g%` | Cycle through matches |
| `[%` | Jump to previous unmatched |
| `]%` | Jump to next unmatched |

### nvim-autopairs
**What**: Automatically closes `(`, `[`, `{`, `'`, `"` as you type. No keybinds needed.

### vim-swap
**What**: Swap function arguments or comma-separated items.

| Key | What it does |
|-----|-------------|
| `g>` | Swap the current parameter right |
| `g<` | Swap the current parameter left |
| `gS` | Interactive swap |

### better-escape.vim
**What**: Press `jk` or `jj` quickly in insert mode to exit to normal mode (instead of `<Esc>`). The timeout is 200ms.

---

## 4. Navigation & File Management

### oil.nvim — File Explorer
**What**: A modern file explorer that opens the parent directory as a regular buffer you can edit.

| Key | What it does |
|-----|-------------|
| `-` | Open parent directory in oil |
| In oil buffer: `Enter` | Open file/directory under cursor |
| In oil buffer: Edit text | Rename files by editing the filename directly |
| In oil buffer: `-` | Go up a directory |

### harpoon — Quick File Switching (Harpoon 2)
**What**: "Bookmark" files for instant switching, like hot-keyed bookmarks.

| Key | What it does |
|-----|-------------|
| `,a` | Add current file to your harpoon list |
| `<C-e>` | Toggle the harpoon quick menu (then select with numbers) |
| `<A-1>` | Jump to harpoon file #1 |
| `<A-2>` | Jump to harpoon file #2 |
| `<A-3>` | Jump to harpoon file #3 |
| `<A-4>` | Jump to harpoon file #4 |

Tip: Harpoon your most-used files (config, main entry points) and jump between them instantly.

### Snacks.nvim — Picker (Fuzzy Finder)
**What**: File finder, text search, and more. Replaces telescope.

| Key | What it does |
|-----|-------------|
| `, f f` | Find files by name (fuzzy) |
| `, f r` | Recent files |
| `, f g` | Live grep — search for text in project files |

### vim-tmux-navigator
**What**: Seamless pane navigation between Neovim and tmux.

| Key | What it does |
|-----|-------------|
| `<C-h>` | Move to left pane/window |
| `<C-j>` | Move to pane below |
| `<C-k>` | Move to pane above |
| `<C-l>` | Move to right pane/window |

Works across both Neovim splits and tmux panes seamlessly.

---

## 5. Search & Find

### nvim-hlslens
**What**: Enhances `*`, `#`, `n`, `N` search with improved highlighting showing occurrence counts on the scrollbar.

| Key | What it does |
|-----|-------------|
| `*` | Search forward for word under cursor (with hlslens overlay) |
| `#` | Search backward for word under cursor |
| `n` | Next match (with hlslens overlay) |
| `N` | Previous match |

### glance.nvim
**What**: Shows LSP references/definitions/implementations in a side panel instead of jumping away.

| Key | What it does |
|-----|-------------|
| `<space>gd` | **G**lance **d**efinitions — show definitions in side panel |
| `<space>gr` | **G**lance **r**eferences — show references in side panel |
| `<space>gi` | **G**lance **i**mplementations — show implementations |

Inside the glance panel:
- Navigate with `j`/`k`
- Press `Enter` to jump to the selected location
- Press `q` to close

---

## 6. Coding & Language Support

### Treesitter (nvim-treesitter)
**What**: Better syntax highlighting, code folding, and text objects. Parses code into an AST (Abstract Syntax Tree) for more accurate highlighting. Supported languages: python, cpp, java, lua, vim, json, toml, markdown, html, css, javascript, typescript, tsx.

**No direct keybinds** — works automatically in the background.

### nvim-treesitter-textobjects
**What**: Adds text objects based on code structure (functions, classes, parameters).

| Key | Mode | What it selects |
|-----|------|----------------|
| `af` | Visual/Operator | **A** **f**unction (outer — includes body) |
| `if` | Visual/Operator | **I**nner **f**unction (just the body) |
| `ac` | Visual/Operator | **A** **c**lass (outer — includes body) |
| `ic` | Visual/Operator | **I**nner **c**lass (just the body) |

These work with `d`, `c`, `y`, `v` etc. Example: `daf` = delete a function, `yif` = yank (copy) function body only.

### Mason (mason.nvim + mason-lspconfig.nvim)
**What**: Installs LSP servers, linters, formatters, and DAP adapters automatically.

| Command | What it does |
|---------|-------------|
| `:Mason` | Open the Mason UI to see installed tools and install new ones |

Automatically installed LSP servers:
- **pyright** — Python language server
- **ruff** — Python linter/formatter
- **lua_ls** — Lua language server
- **clangd** — C/C++ language server

### LSP Configuration (nvim-lspconfig)
**What**: Configures LSP servers and provides LSP keybindings.

| Key | Mode | What it does |
|-----|------|-------------|
| `gd` | Normal | **G**o to **d**efinition — jumps to where the thing under cursor is defined |
| `<C-]>` | Normal | Alternative go-to-definition |
| `K` | Normal | **H**over — shows documentation, type info, and docstring for the thing under cursor |
| `<C-k>` | Insert | **S**ignature **h**elp — shows function parameter info as you type arguments |
| `<space>rn` | Normal | **R**e**n**ame — rename variable/function/class across the entire project |
| `<space>ca` | Normal | **C**ode **a**ction — shows available refactoring options (e.g. extract variable, organize imports) |
| `<space>wa` | Normal | Add workspace folder |
| `<space>wr` | Normal | Remove workspace folder |
| `<space>wl` | Normal | List workspace folders |

Per-language LSP servers:
- **Python**: pyright (main) + ruff (linting/formatting only, hover disabled in favor of pyright)
- **C/C++**: clangd
- **Java**: jdtls (managed by nvim-java plugin)
- **Lua**: lua_ls (with LuaJIT runtime hints enabled)

### nvim-cmp — Autocompletion
**What**: The completion popup that appears as you type, showing suggestions from LSP, snippets, paths, buffer words, and AI.

**How it works**:
- Start typing — a menu appears automatically
- Select an item and press Enter to confirm

| Key | Mode | What it does |
|-----|------|-------------|
| `<C-n>` | Insert (in menu) | Select next item |
| `<C-p>` | Insert (in menu) | Select previous item |
| `<C-y>` | Insert (in menu) | Confirm selection |
| `<C-e>` | Insert (in menu) | Close the completion menu |
| `<C-d>` | Insert (in menu) | Scroll documentation down |
| `<C-f>` | Insert (in menu) | Scroll documentation up |

**Completion sources** (in priority order):
1. `lazydev` — Lua development completions for Neovim API
2. `nvim_lsp` — Completions from the active LSP server (main source)
3. `path` — File path completions (`/home/`, `./`, `../`)
4. `buffer` — Words from current and recent buffers
5. `supermaven` — AI-powered completions

### LuaSnip — Snippets
**What**: Provides snippet expansion. When you type a snippet trigger and press the expansion key, it expands into a template with tab-stops you can jump through.

| Key | Mode | What it does |
|-----|------|-------------|
| `<C-j>` | Insert | Expand snippet (also configured as UltiSnips trigger) |
| `<C-j>` | Insert (in snippet) | Jump forward to next tab-stop |
| `<C-k>` | Insert (in snippet) | Jump backward to previous tab-stop |

Snippet directories: `my_snippets/` and `UltiSnips/` (standard UltiSnips format).

### Supermaven — AI Completions
**What**: AI-powered code completions (like GitHub Copilot). Suggests the next line(s) of code as you type. Integrates into the nvim-cmp menu automatically. No extra keybinds needed.

### none-ls.nvim — Linters & Formatters
**What**: Integrates external linters and formatters into Neovim's LSP infrastructure. Format on save is enabled.

| Tool | What it does |
|------|-------------|
| **prettier** | Formats JavaScript, TypeScript, CSS, HTML, JSON, Markdown |
| **clang-format** | Formats C, C++ code |
| **black** | Formats Python code |

Files are automatically formatted when you save (`:w`).

### nvim-java — Java IDE
**What**: Full Java IDE support including:
- JDTLS language server (downloads and manages its own)
- Project management (Maven/Gradle)
- Test running
- Debugging via nvim-dap

No extra keybinds needed — uses the standard LSP keybinds (`gd`, `K`, `<space>ca`, etc.). Java support activates automatically when you open a `.java` file.

### typescript-tools.nvim
**What**: Enhanced TypeScript/JavaScript LSP (wraps tsserver). Activates on `.ts`, `.tsx`, `.js`, `.jsx` files. Includes JSX close tag support.

### nvim-colorizer.lua
**What**: Highlights color codes (`#ff0000`, `rgb(255,0,0)`, `red`) with their actual color in the buffer. Works automatically.

### tailwindcss-colorizer-cmp.nvim
**What**: Shows Tailwind CSS color swatches next to class name completions in the completion menu.

---

## 7. Git Integration

### gitsigns.nvim
**What**: Shows git diff signs (`+`, `~`, `_`) in the sign column and provides hunk operations.

In the sign column:
- `+` = Added line
- `~` = Modified line
- `_` = Deleted line
- `‾` = Deleted lines at top
- `│` = Modified and deleted

| Key | Mode | What it does |
|-----|------|-------------|
| `]c` | Normal | Go to next git hunk (changed block) |
| `[c` | Normal | Go to previous git hunk |
| `,hp` | Normal | **P**review the current hunk's diff |
| `,hb` | Normal | **B**lame the current line (shows who last changed it and when) |

### vim-fugitive — Git Commands
**What**: Run Git commands from inside Neovim.

| Key | Mode | What it does |
|-----|------|-------------|
| `,gs` | Normal | **G**it **s**tatus — opens the Git status window |
| `,gw` | Normal | **G**it **w**rite — stage current file (`git add`) |
| `,gc` | Normal | **G**it **c**ommit — opens commit message editor |
| `,gpl` | Normal | **G**it **p**ul**l** — pull from remote |
| `,gpu` | Normal | **G**it **p**ush — push to remote |
| `,gb` | Visual | **G**it **b**lame — blame the selected lines |
| `,gbn` | Normal | Create a **n**ew branch (prompts for name) |
| `,gf` | Normal | Git fetch (then type the remote name) |
| `,gbd` | Normal | **D**elete a branch (then type branch name) |

Inside the status window (`,gs`):
- Press `-` to stage/unstage a file
- Press `cc` to commit
- Press `p` to push
- Press `?` for all keybinds

### git-conflict.nvim
**What**: Helps resolve merge conflicts with a UI. When a conflict marker (`<<<<<<<`, `=======`, `>>>>>>>`) is detected:

| Key | What it does |
|-----|-------------|
| `:GitConflictListQf` | List all conflicts in quickfix |
| Various next/prev commands | Navigate between conflicts |

When a conflict is resolved, the quickfix list is automatically refreshed.

### diffview.nvim
**What**: Shows Git diffs in a side-by-side view.

| Command | What it does |
|---------|-------------|
| `:DiffviewOpen` | Open diff view for current changes |
| `:DiffviewOpen HEAD~1` | Compare with one commit ago |
| `:DiffviewOpen main...HEAD` | Compare branch with main |

### yanky.nvim — Yank History
**What**: Remembers everything you yank (copy) and allows cycling through the history after pasting.

| Key | Mode | What it does |
|-----|------|-------------|
| `p` | Normal/Visual | Paste after cursor (uses yanky instead of default) |
| `P` | Normal/Visual | Paste before cursor |
| `[y` | Normal (after paste) | Cycle backward through yank history |
| `]y` | Normal (after paste) | Cycle forward through yank history |

Example: Press `p` to paste, then press `]y` repeatedly to cycle through previously yanked text.

---

## 8. Debugging — nvim-dap + nvim-dap-ui

**What**: Debug Adapter Protocol — set breakpoints and step through code. DAP UI provides a visual debugger with views for variables, stack trace, watches, etc.

| Key | Mode | What it does |
|-----|------|-------------|
| `<F5>` | Normal | **T**oggle **b**reakpoint on current line |
| `,ds` | Normal | **S**tart or continue debugging |
| `<F10>` | Normal | **S**tep **o**ver — execute current line, stop at next |
| `<F11>` | Normal | **S**tep **i**nto — go inside the function call |
| `<F12>` | Normal | **S**tep **o**ut — finish current function and return |
| `,du` | Normal | **T**oggle the **D**AP **U**I panel |

DAP UI windows automatically open when debugging starts and close when it ends. Windows include:
- **Variables** — see current variable values
- **Stack** — call stack with frames
- **Watches** — expressions you're watching
- **Console** — REPL for evaluating expressions
- **Breakpoints** — list of all breakpoints

Installed DAP adapter: `cpptools` (for C/C++ debugging via Mason).

---

## 9. Code Folding — nvim-ufo

**What**: Folds code blocks (functions, classes, imports) so you can hide/show them.

| Key | What it does |
|-----|-------------|
| `za` | Toggle fold under cursor |
| `zR` | **R**eopen **a**ll folds — unfold everything |
| `zM` | Close **a**ll folds |
| `zr` | Reduce fold level (open one more level) |
| `zm` | Fold more (close one more level) |
| `,K` | **P**review folded lines under cursor without opening |

The fold indicator shows `󰁂` with the count of folded lines.

---

## 10. Notes & Knowledge — obsidian.nvim

**What**: Integrates with Obsidian note-taking app. Works with your notes directory at `~/notes/`.

| Key | What it does |
|-----|-------------|
| `gf` | Follow a `[[wikilink]]` under cursor (or normal `gf` if not on a link) |
| `,oo` | Open current note in Obsidian app |
| `,on` | Create a new Obsidian note |
| `,os` | Search notes (fuzzy) |
| `,ot` | Open today's daily note |

---

## 11. LeetCode — leetcode.nvim

**What**: Solve LeetCode problems inside Neovim. Default language is C++.

| Key | What it does |
|-----|-------------|
| `,l` | Open LeetCode menu |

Then use the menu to browse problems, pick one, solve it, and test/submit.

---

## 12. Databases — vim-dadbod + vim-dadbod-ui

**What**: Query databases from Neovim.

| Command | What it does |
|---------|-------------|
| `:DBUI` | Open database browser UI |

Saved queries are stored in `~/.config/nvim/db_ui_queries/`.

---

## 13. Markdown — vim-markdown

**What**: Enhanced Markdown editing with syntax highlighting, folding, and concealment.

Features:
- Headers are foldable
- `[links](url)` are highlighted
- Can use `:Toc` to show table of contents

---

## 14. Miscellaneous

### vim-eunuch
**What**: Unix command helpers for Vim.

| Command | What it does |
|---------|-------------|
| `:Rename newname.txt` | Rename the current file |
| `:Delete` | Delete the current file and remove from buffer |
| `:Move path/to/new.txt` | Move the current file |
| `:Chmod +x` | Make current file executable |

### vim-repeat
**What**: Makes `.` (dot-repeat) work with plugin commands like vim-sandwich, vim-commentary, vim-swap. No keybinds — works automatically.

### vim-toml
**What**: Syntax highlighting for TOML files (e.g. `Cargo.toml`, `pyproject.toml`). Activates automatically.

### mini.indentscope
**What**: Shows a thin vertical line (`▏`) at the current indentation level, helping you see code structure.

### leetcode.nvim
**What**: Solve LeetCode problems in Neovim.

| Key | What it does |
|-----|-------------|
| `,l` | Open LeetCode menu |

---

## 15. Custom Plugin: Manga Reader (lua/manga/)

**What**: A custom-built manga reader that downloads and displays manga chapters from the MangaDex API inside Neovim (as image rendering in buffers).

| Command | What it does |
|---------|-------------|
| `:MangaSearch` | Search and open a manga chapter |
| `:MangaOpenLocal <dir>` | Open a local directory of manga images |
| `:MangaNext` | Go to next page |
| `:MangaPrev` | Go to previous page |
| `:MangaQuit` | Close the manga reader |
| `:MangaStatus` | Show reading progress |

---

## 16. General Mappings (from mappings.lua)

These work everywhere, regardless of filetype:

| Key | Mode | What it does |
|-----|------|-------------|
| `;` | Normal/Visual | Enters command-line mode (no Shift needed) |
| `,w` | Normal | **W**rite (save) current buffer |
| `,q` | Normal | Save and **q**uit current window |
| `,Q` | Normal | **Q**uit Neovim entirely (force, no save) |
| `,p` | Normal | Paste below current line (without moving cursor) |
| `,P` | Normal | Paste above current line (without moving cursor) |
| `\x` | Normal | **C**lose quickfix and location list windows |
| `\d` | Normal | **D**elete current buffer (keep window) |
| `\D` | Normal | **D**elete all other buffers (keep current) |
| `<space>o` | Normal | Insert blank line **b**elow (cursor stays) |
| `<space>O` | Normal | Insert blank line **a**bove (cursor stays) |
| `H` | Normal/Visual | Go to start of line (like `^`) |
| `L` | Normal/Visual | Go to end of line (like `g_`) |
| `,ev` | Normal | **E**dit **v**imrc — open `init.lua` in a new tab |
| `,sv` | Normal | **S**ource **v**imrc — reload the config |
| `,v` | Normal | Reselect last pasted text |
| `,cd` | Normal | **C**hange **d**irectory to current file's location |
| `j` / `k` | Normal | Move by visual lines (handles wrapped lines) |
| `<A-k>` | Normal | Move current line up |
| `<A-j>` | Normal | Move current line down |
| `<A-k>` | Visual | Move selection up |
| `<A-j>` | Visual | Move selection down |
| `<C-A>` | Insert | Go to beginning of line |
| `<C-E>` | Insert | Go to end of line |
| `<C-D>` | Insert | Delete character after cursor |
| `,ts` | Normal/Insert | **T**oggle **s**pell check |
| `,cl` | Normal | Toggle cursor column/line highlight |
| `,y` | Normal | **Y**ank (copy) entire buffer |
| `<space><space>` | Normal | Remove trailing whitespace |
| `<left>` | Normal | Go to left window |
| `<right>` | Normal | Go to right window |
| `<up>` | Normal | Go to window above |
| `<down>` | Normal | Go to window below |
| `Esc` | Terminal | Exit terminal mode to normal mode |
| `<A-;>` | Insert | Insert semicolon at end of line |
| `J` | Normal | Join lines without moving cursor |
| `gb` | Normal | Go to buffer (forward, use with count e.g. `3gb`) |
| `gB` | Normal | Go to buffer (backward) |

### Diagnostic-related:

| Key | What it does |
|-----|-------------|
| `<space>qw` | Put all window diagnostics into quickfix list |
| `<space>qb` | Put current buffer diagnostics into quickfix list |

Diagnostics (errors/warnings from LSP) also auto-show in a floating window when you stop moving the cursor on a line with a diagnostic.

---

## 17. Startup & Config

Your config is at `~/.config/nvim/init.lua`. All Lua modules are in `~/.config/nvim/lua/`.

### Quick Config Editing

| Key | What it does |
|-----|-------------|
| `,ev` | Open init.lua in a new tab |
| `,sv` | Save and reload the config |

### Autocommands (custom-autocmd.lua)

- **Yank highlight**: Text briefly highlights green (`#2ECC71`) when yanked
- **Auto-create dir**: When you save a file in a directory that doesn't exist, the directory is created automatically
- **Auto-reload**: If a file changes on disk, Neovim detects it and reloads
- **Auto-resize**: Windows resize evenly when the terminal is resized
- **Large file optimization**: Files over 0.5MB disable features (syntax, undo, numbers) for performance
- **Relative number toggle**: Line numbers become relative in normal mode, absolute in insert mode

---

## 18. LSP Diagnostics & Errors

When your code has errors or warnings:
- Icons appear in the sign column: `🆇` (error), `⚠️` (warn), `ℹ️` (info), `` (hint)
- Hover your cursor over a line with a diagnostic — a floating window appears automatically after a moment showing the error message
- No underlines or virtual text (keeps the buffer clean)

---

## Quick Reference — Most Important Keybinds

| Key | What it does |
|-----|-------------|
| `K` | Hover — show docs for symbol under cursor |
| `gd` | Go to definition |
| `<space>gd` | Glance: show definitions in side panel |
| `<space>gr` | Glance: show references in side panel |
| `<space>ca` | Code action (refactoring menu) |
| `<space>rn` | Rename symbol across project |
| `,w` | Save file |
| `,q` | Save and quit |
| `,a` | Add file to harpoon |
| `<A-1>` to `<A-4>` | Jump to harpoon files 1-4 |
| `,f f` | Find file by name |
| `,f g` | Search text in project (grep) |
| `-` | Open file explorer (oil) |
| `,gs` | Git status |
| `,hp` | Preview git hunk |
| `<F5>` | Toggle breakpoint |
| `gcc` | Comment/uncomment line |
| `sa` + motion + char | Add surround (e.g. `saiw"`) |
| `zR` / `zM` | Open/close all folds |
| `%` | Jump to matching bracket/keyword |
| `;` | Enter command mode |
| `<C-k>` | Signature help (inside function args) |
