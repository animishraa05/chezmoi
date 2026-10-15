# qutebrowser configuration

Personal qutebrowser configuration — Vim-style keybindings, space leader, and
a [Vague](https://github.com/maria-crisan/neovim) colour scheme shared with the
rest of the desktop setup.

## Layout

```
config.py              main config: keybindings, search engines, adblocking
config/variable.py     reads .env and exposes the values used by config.py
libs/utility.py        small helpers (to_bool)
themes/vague.py        Vague colour scheme
greasemonkey/          userscripts (YouTube ad skipping)
quickmarks             nickname -> URL shortcuts
bookmarks/urls         bookmark list (searchable via `space m`)
autoconfig.yml         qutebrowser-generated GUI settings
.env                   machine-specific values (git-ignored)
```

## Setup

Dependencies:

- `python-dotenv` — read by `config/variable.py`
- `adblock` (python-adblock) — optional, enables Brave's ABP filter engine

Clone into place:

```bash
git clone https://github.com/animishraa05/qutebrowser-config.git ~/.config/qutebrowser
cd ~/.config/qutebrowser
make init
```

Then edit `.env` and set at least the path variables:

| Variable | Purpose |
| --- | --- |
| `LEADER_KEY` | key prefix for the leader bindings (`space` here) |
| `SCREENSHORT_DIR` | where `space s` saves screenshots |
| `DOWNLOAD_DIR` | download target and `; I` image target |
| `TERMINAL` | terminal used for editor and file chooser |
| `EDITOR` | editor used for `space c` / `space e` |
| `GITHUB_USERNAME` | drives the `space A` profile shortcut |
| `HOMEPAGE` | start page and blank page target |
| `FONT_FAMILY` / `FONT_SIZE` | UI font |
| `CANVAS`, `WEBGL` | render feature toggles |
| `DARKMODE` | force dark rendering on websites |

Reload with `<space> r`, or restart qutebrowser.

## Keybindings

Leader is `<space>`.

| Key | Action |
| --- | --- |
| `t` | open in new tab |
| `O` / `P` | open in new window / private window |
| `K` / `J` | back / forward |
| `H` / `L` | previous / next tab |
| `Q` | close tab |
| `p` | pin tab |
| `<Ctrl-Shift-=>` / `<Ctrl-Shift-->` | zoom in / out |
| `<Ctrl-Shift-Backspace>` | reset zoom |

### Splitting

qutebrowser has no native split panes. Instead the current page is cloned into
a new window and your window manager tiles it, so a split is two coordinated
windows rather than two panes in one.

| Key | Action |
| --- | --- |
| `<space>-` | clone current page into a new window (tiled beside the current one) |
| `mod+h` / `mod+l` | move focus to the left / right window |
| `mod+z` / `mod+shift+v` | change the split orientation |

To remove one side without losing the page, merge it back instead of closing
it:

| Key | Action |
| --- | --- |
| `<space>w` | pull a tab from another window into this one |
| `<space>W` | send this tab to another window |

So: focus the window you want to keep, press `<space>w`, pick the tab, then
`<space>Q` on the window you just emptied. The window manager refills the space
automatically.

| Leader | Action |
| --- | --- |
| `<space> b` / `<space> B` | toggle status bar / tab bar |
| `<space> c` / `<space> C` | edit config / edit settings |
| `<space> d` / `<space> D` | devtools / focus devtools |
| `<space> e` / `<space> E` | edit page text / edit command |
| `<space> m` / `<space> M` | list bookmarks / add bookmark |
| `<space> .` | load a quickmark |
| `<space> h` / `<space> H` | history / help |
| `<space> n` / `<space> N` | clone tab / clone into new window |
| `<space> r` / `<space> R` | reload config / restart |
| `<space> s` | screenshot to `SCREENSHORT_DIR` |
| `<space> t` / `<space> T` | select tab / close other tabs |
| `<space> u` | reopen closed tab |
| `<space> v` / `<space> V` | play link in mpv / download with yt-dlp |
| `<space> w` / `<space> W` | take tab from window / give tab to window |
| `<space> x` | save session and quit |
| `<space> y` | yank a link |

Other bindings: `; w` / `; W` play in mpv, `; I` download an image,
`e e` / `e u` / `e p` / `e o` fill credentials from `pass`.

## Adblocking

`content.blocking.method` is `both`: Brave's ABP engine (`adblock` package)
plus a hosts blocker. The ABP lists live in `content.blocking.adblock.lists`
in `config.py`.

Brave's engine only filters network requests — it does not do cosmetic
(element hiding) filtering, which is what the `greasemonkey/youtube-ads.js`
userscript is for.

Update lists with `:adblock-update` (or `:adblock-update` for hosts too).

## License

MIT