// user.js — Zen Browser persistent preferences
// Applied on every launch, overriding prefs.js.

// Scale everything (UI + web pages) to 140%
// -1.0 = system default, 1.4 = 140%
user_pref("layout.css.devPixelsPerPx", "1.4");

// Start page: the Vague startpage, same file qutebrowser uses.
user_pref("browser.startup.page", 1);
user_pref("browser.startup.homepage", "file:///home/ani/.config/startpage/index.html");
