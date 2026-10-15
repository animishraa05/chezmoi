# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

from config.variable import Variable

# Load autoconfig
var = Variable()

# Reassign to avoid lsp(ruff_lsp) errors
config = config  # noqa: F821
c = c  # noqa: F821

config.load_autoconfig()

# General
c.editor.command = [getattr(var, "terminal"), "-e", getattr(var, "editor"), "{}"]
c.downloads.location.directory = getattr(var, "dl_dir")
c.zoom.default = "110%"
c.tabs.show = "switching"
c.statusbar.show = "in-mode"
c.auto_save.session = True
c.url.auto_search = "naive"
c.completion.height = "33%"
c.downloads.position = "bottom"
c.input.insert_mode.auto_load = True
c.spellcheck.languages = ["en-US"]
c.confirm_quit = ["never"]

# Persistent session
c.session.default_name = "default"
c.session.lazy_restore = True

# Tabs
c.tabs.favicons.scale = 1.0
c.tabs.background = True

# User agent
#
# Deliberately left at qutebrowser's default. The default is assembled from the
# running engine ({upstream_browser_version_short} -> Chrome/<major>), so it
# always agrees with QtWebEngine and no longer advertises QtWebEngine either
# (changed in v3.5.0). A hardcoded UA is a fingerprint mismatch: Google refused
# Google sign-in because the config claimed Chrome/120 while the engine was
# Chromium 140. Don't set this unless you have a specific reason to.

# Dark mode
config.set("colors.webpage.darkmode.enabled", getattr(var, "darkmode"))
config.set("colors.webpage.preferred_color_scheme", "auto")

# File handling
config.set("fileselect.handler", "external")
config.set(
    "fileselect.single_file.command",
    [
        getattr(var, "terminal"),
        "-e",
        "yazi",
        "--chooser-file={}",
    ],
)
config.set(
    "fileselect.multiple_files.command",
    [
        getattr(var, "terminal"),
        "-e",
        "yazi",
        "--chooser-files={}",
    ],
)

# Adblocking
# `python-adblock` binds Brave's Rust adblock-rust engine. Note upstream
# python-adblock is unmaintained (see qutebrowser discussion #8935), but
# the Arch package still works and gives ABP-syntax network filtering.
#
# Brave's engine blocks network requests only - it does NOT do cosmetic
# (element hiding) filtering. That is why the greasemonkey YouTube script
# below still earns its keep.
config.set("content.blocking.method", "both")
config.set("content.blocking.enabled", True)

# ABP-syntax filter lists fed to Brave's engine.
# Raw URLs only - qutebrowser cannot follow subscribe.adblockplus.org links.
config.set(
    "content.blocking.adblock.lists",
    [
        # Ad / tracking core
        "https://easylist.to/easylist/easylist.txt",
        "https://easylist.to/easylist/easyprivacy.txt",
        # uBlock filters (maintained superset of EasyList)
        "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt",
        # Annoyances: cookie banners, generic hiding, popups
        "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/annoyances.txt",
        # Unbreak: fixes broken sites caused by over-blocking
        "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt",
        # Malware / badware
        "https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/badware.txt",
    ],
)

# /etc/hosts-style lists for the simple host blocker (belt and braces).
# This is also qutebrowser's own default, set explicitly so it survives
# future default changes.
config.set(
    "content.blocking.hosts.lists",
    [
        "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts",
    ],
)

# Theme
config.source("themes/vague.py")

# Set fonts
c.fonts.default_size = getattr(var, "font_size")
c.fonts.default_family = getattr(var, "font_family")
c.fonts.completion.entry = getattr(var, "font")
c.fonts.hints = getattr(var, "font")
c.fonts.debug_console = getattr(var, "font")
c.fonts.prompts = getattr(var, "font")
c.fonts.statusbar = getattr(var, "font")

# Content
c.content.pdfjs = True
c.content.autoplay = False
c.content.canvas_reading = getattr(var, "canvas")
c.content.webgl = getattr(var, "webgl")

# Home page
c.url.open_base_url = True
c.url.start_pages = getattr(var, "homepage")
c.url.default_page = getattr(var, "homepage")

# Search engines
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "am": "https://amazon.com/s?k={}",
    "aw": "https://wiki.archlinux.org/?search={}",
    "bn": "https://bing.com/search?q={}",
    "gh": "https://github.com/search?q={}",
    "gg": "https://google.com/search?q={}",
    "gho": "https://github.com/{}",
    "ghr": "https://github.com/" + getattr(var, "username") + "/{}",
    "jr": "https://springhealth.atlassian.net/browse/{}",
    "mp": "https://google.com/maps?q={}",
    "rd": "https://reddit.com/search/?q={}",
    "rds": "https://reddit.com/r/{}",
    "rt": "https://rottentomatoes.com/search?search={}",
    "so": "https://stackoverflow.com/search?q={}",
    "sp": "https://open.spotify.com/search/{}",
    "tw": "https://twitter.com/search?q={}",
    "ud": "https://urbandictionary.com/define.php?term={}",
    "wk": "https://en.wikipedia.org/wiki/{}",
    "yt": "https://youtube.com/results?search_query={}",
    "ytm": "https://music.youtube.com/search?q={}",
    "wa": "https://wiki.archlinux.org/?search={}",
}

# Aliases
c.aliases = {
    "o": "open",
    "q": "quit",
    "Q": "close",
    "w": "session-save",
    "x": "quit --save",
}

# Keybindings
config.bind("t", "cmd-set-text -s :open -t")
config.bind("O", "cmd-set-text -s :open -w")
config.bind("P", "cmd-set-text -s :open -p")
config.bind("W", "tab-clone -w")
config.bind("a", "mode-enter insert")

config.bind("K", "back")
config.bind("J", "forward")
config.bind("H", "tab-prev")
config.bind("L", "tab-next")
config.bind("Q", "tab-close")

# Zoom - matches kitty.conf (ctrl+shift+equal / minus / backspace)
#
# With a US layout, Shift+= actually produces "+" and Shift+- produces "_",
# so Qt reports Key_Plus / Key_Underscore - not Key_Equal / Key_Minus. Bind
# the shifted characters, and keep the unshifted ones as fallbacks in case a
# different layout reports the unshifted keys.
config.bind("<Ctrl-Shift-+>", "zoom-in")
config.bind("<Ctrl-Shift-=>", "zoom-in")
config.bind("<Ctrl-Shift-_>", "zoom-out")
config.bind("<Ctrl-Shift-->", "zoom-out")
config.bind("<Ctrl-Shift-Backspace>", "zoom")

config.bind(
    getattr(var, "leader") + "A",
    "open -t https://github.com/" + getattr(var, "username") + "/",
)
# Split: clone current page into a new window. i3 tiles it side by side.
config.bind(getattr(var, "leader") + "-", "tab-clone -w")
config.bind(getattr(var, "leader") + "b", "config-cycle statusbar.show always in-mode")
config.bind(getattr(var, "leader") + "B", "config-cycle tabs.show multiple switching")
config.bind(getattr(var, "leader") + "c", "config-edit")
config.bind(getattr(var, "leader") + "C", "cmd-set-text -s :set -t")
config.bind(getattr(var, "leader") + "d", "devtools")
config.bind(getattr(var, "leader") + "D", "devtools-focus")
config.bind(getattr(var, "leader") + "e", "edit-text")
config.bind(getattr(var, "leader") + "E", "cmd-edit")
config.bind(getattr(var, "leader") + "i", "hint inputs")
config.bind(getattr(var, "leader") + "h", "history")
config.bind(getattr(var, "leader") + "H", "help")
config.bind(getattr(var, "leader") + "m", "bookmark-list")
config.bind(getattr(var, "leader") + "M", "bookmark-add")
config.bind(
    getattr(var, "leader") + ".",
    "cmd-set-text -s :quickmark-load",
)
config.bind(getattr(var, "leader") + "n", "tab-clone")
config.bind(getattr(var, "leader") + "N", "tab-clone -w")
config.bind(getattr(var, "leader") + "o", "hint links window")
config.bind(getattr(var, "leader") + "O", "hint links run :open -p {hint-url}")
config.bind(getattr(var, "leader") + "p", "tab-pin")
config.bind(getattr(var, "leader") + "P", "cmd-set-text -s :tab-move")
config.bind(getattr(var, "leader") + "q", "tab-close")
config.bind(getattr(var, "leader") + "Q", "close")
config.bind(getattr(var, "leader") + "r", "config-source")
config.bind(getattr(var, "leader") + "R", "restart")
config.bind(
    getattr(var, "leader") + "s",
    "screenshot "
    + getattr(var, "ss_dir")
    + "qute-"
    + getattr(var, "timestamp")
    + ".png",
)
config.bind(getattr(var, "leader") + "S", "view-source --edit")
config.bind(getattr(var, "leader") + "t", "cmd-set-text -s :tab-select")
config.bind(getattr(var, "leader") + "T", "tab-only")
config.bind(getattr(var, "leader") + "u", "undo")
config.bind(getattr(var, "leader") + "v", "hint links spawn mpv {hint-url}")
config.bind(
    getattr(var, "leader") + "V",
    "hint links spawn " + getattr(var, "terminal") + "-e yt-dlp {hint-url}",
)
config.bind(getattr(var, "leader") + "w", "cmd-set-text -s :tab-take")
config.bind(getattr(var, "leader") + "W", "tab-give")
config.bind(getattr(var, "leader") + "y", "hint links yank")
config.bind(getattr(var, "leader") + "x", "quit --save")
config.bind(getattr(var, "leader") + "X", "window-only")

config.bind("p", "tab-pin")
config.bind(";w", "hint link spawn --detach mpv --force-window yes {hint-url}")
config.bind(";W", "spawn --detach mpv --force-window yes {url}")
config.bind(
    ";I",
    "hint images spawn --output-message wget -P "
    + getattr(var, "dl_dir")
    + "images/ -c {hint-url}",
)

# Password management
config.bind("ee", "spawn --userscript qute-pass")
config.bind("eu", "spawn --userscript qute-pass --username-only")
config.bind("ep", "spawn --userscript qute-pass --password-only")
config.bind("eo", "spawn --userscript qute-pass --otp-only")
