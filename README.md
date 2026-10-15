# Dotfiles

A complete Arch Linux desktop, managed with [chezmoi](https://www.chezmoi.io/).

i3 + polybar, kitty + fish + tmux, and the **Vague** colour scheme applied
across every application so the whole desktop reads as one system.

---

## What's in here

| Area | App | Notes |
| --- | --- | --- |
| WM | i3 | `colors.conf` (Vague), `mod+B` opens qutebrowser, `mod+q` saves session |
| Bar | polybar | `aniii_colors.ini` is the single palette file |
| Launcher | rofi | all menus `@import "base.rasi"`, palette lives there |
| Terminal | kitty | fish shell, tmux prefix `C-a` |
| Editor | neovim | lazy.nvim, Vague colourscheme |
| Browser | qutebrowser | Vim bindings, space leader, ABP adblocking |
| Files | yazi | custom Vague flavour |
| Notifications | dunst | Vague urgency colours |
| Editor config | wezterm, alacritty, zed, lazygit, fastfetch | |

**Theme:** every app uses the Vague palette, sourced from the neovim config
(`nvim/lua/colorschemes.lua`). Change it in one place and the rest follows.

---

## Fresh install

On a clean Arch system you need only `git` and `chezmoi` to begin:

```bash
sudo pacman -S --needed git chezmoi
```

Then apply:

```bash
chezmoi init --apply https://github.com/animishraa05/chezmoi.git
```

That's it. The apply triggers two one-shot scripts:

1. **`run_once_before_10-install-packages.sh`** — installs every package the
   dotfiles reference (i3, kitty, polybar, rofi, dunst, picom, yazi,
   qutebrowser, `python-adblock`, `ttf-jetbrains-mono-nerd`, …) via
   `pacman -S --needed`. Already-installed packages are skipped, so it is
   safe to re-run.
2. **`run_once_after_20-setup-runtime.sh`** — handles what chezmoi can't
   manage: creates `~/.config/qutebrowser/.env`, installs the QtWebEngine
   spellcheck dictionary, clones TPM and its plugins, and runs
   `fisher update`.

Then **log out and back in** (or reboot) so the `i3` autostart picks up.

### Afterwards

```bash
# qutebrowser's .env holds machine-specific paths - edit it once
$EDITOR ~/.config/qutebrowser/.env
```

Set at least:

| Variable | Example |
| --- | --- |
| `SCREENSHORT_DIR` | `/home/you/Pictures/Captures/` |
| `DOWNLOAD_DIR` | `/home/you/Downloads/` |
| `GITHUB_USERNAME` | `your-username` |
| `HOMEPAGE` | `https://duckduckgo.com/` |

Without `.env`, qutebrowser refuses to start (`config/variable.py` aborts on
the missing values).

Neovim plugins install themselves on first launch via lazy.nvim.

---

## Daily use

```bash
chezmoi diff          # preview changes
chezmoi apply         # apply them
chezmoi status        # what is out of sync
chezmoi update        # pull, then apply
```

After editing a dotfile:

```bash
chezmoi add ~/.config/<app>/<file>
chezmoi diff && chezmoi apply
git -C "$(chezmoi source-path)" commit -am "..." && git -C "$(chezmoi source-path)" push
```

---

## Notes and gotchas

**qutebrowser lives in two repos.** `animishraa05/qutebrowser-config` is the
standalone repo, and the config is *also* vendored here. chezmoi is what
restores it; the other repo is for sharing or tracking upstream. If you edit
qutebrowser, commit in both or they will drift.

**`.env` and `.git` are excluded** via `.chezmoiignore`. The env file holds
machine paths; the nested git dir is not ours to store.

**Hardcoded `/home/ani`.** A number of managed files still reference the
absolute home path (e.g. `i3/keymaps.conf`, `polybar/modules/modules.ini`).
This restores correctly to a machine with the same username. On a different
username, change those lines or convert them to chezmoi templates.

**Secrets.** Keep API keys out of tracked files. `fish/config.fish` is tracked;
put anything sensitive in `~/.config/fish/conf.d/` instead (chezmoi manages
that directory separately and it is easy to exclude).

**Optional packages.** The install script installs a core set. Laptop extras
(`brightnessctl`, `upower`, `betterlockscreen`, `variety`, `nm-applet`) are
commented out in the script — uncomment the ones you want and re-run it.

**Spellcheck.** qutebrowser uses QtWebEngine `.bdic` dictionaries, not
hunspell or aspell. The setup script borrows one from a Chromium app
(vesktop/thorium/obsidian) if present. If none is found, remove
`c.spellcheck.languages` from `qutebrowser/config.py` to silence the warning.

---

## Structure

```
chezmoi/
├── run_once_before_10-install-packages.sh   packages
├── run_once_after_20-setup-runtime.sh       env, dictionary, TPM, fisher
├── .chezmoiignore                          excludes .git/.env/__pycache__
├── dot_tmux.conf
├── dot_config/
│   ├── i3/          polybar/     rofi/      dunst/
│   ├── kitty/       fish/        nvim/      qutebrowser/
│   ├── yazi/        wezterm/     alacritty/ private_fish/
└── dot_local/bin/   tmux-sessionizer
```

Each config app also has its own upstream repo; chezmoi is the source of truth
for a restore, those repos are for history and sharing.

---

## License

MIT