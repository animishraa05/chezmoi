#!/usr/bin/env bash
# Install every package the managed dotfiles depend on.
#
# Runs once, before the rest of the chezmoi apply. Safe to re-run: pacman -S
# on already-installed packages is a no-op, and --needed stops it upgrading
# things you already have.
#
# Uncomment an optional package below to have it installed as well.

set -euo pipefail

PACKAGES=(
    # --- Core / session ---
    i3
    xorg-xinit
    xorg-xrandr
    xorg-xset
    xorg-xinput
    xorg-server
    xorg-xdpyinfo
    xorg-xprop
    xorg-xkill
    xorg-xcursor-themes

    # --- Shell & terminal ---
    fish
    kitty
    starship
    fzf
    git
    tmux
    fisher

    # --- Fonts ---
    ttf-jetbrains-mono-nerd

    # --- Status bar / panels ---
    polybar
    rofi
    dunst
    picom

    # --- File manager ---
    yazi

    # --- Browser ---
    qutebrowser
    python-adblock        # Brave ABP engine for qutebrowser's adblocker

    # --- Media / misc apps referenced by keybindings ---
    mpv
    yt-dlp
    wget
    lazygit
    fastfetch
    feh

    # --- Optional (uncomment to install) ---
    # brightnessctl           # backlight; skip on desktops without one
    # upower                  # power/battery reporting
    # betterlockscreen        # lock screen bound to mod+shift+x
    # variety                 # wallpaper rotation
    # nm-applet               # network tray applet
    # alacritty               # alternative terminal
)

missing=()
for pkg in "${PACKAGES[@]}"; do
    pacman -Qi "$pkg" &>/dev/null || missing+=("$pkg")
done

if [[ ${#missing[@]} -eq 0 ]]; then
    echo "--> all packages already installed"
    exit 0
fi

echo "--> installing ${#missing[@]} package(s):"
printf '    %s\n' "${missing[@]}"

sudo pacman -S --needed --noconfirm "${missing[@]}"

failed=()
for pkg in "${missing[@]}"; do
    pacman -Qi "$pkg" &>/dev/null || failed+=("$pkg")
done

if [[ ${#failed[@]} -gt 0 ]]; then
    echo "!!! could not install: ${failed[*]}" >&2
    echo "!!! check the package name, or drop it from this list." >&2
    exit 1
fi

echo "--> package install complete"