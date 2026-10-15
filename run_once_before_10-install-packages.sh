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
    i3-wm                   # the WM binary is /usr/bin/i3, package is i3-wm
    lightdm                 # login manager; without this there is no way in
    lightdm-gtk-greeter     # greeter lightdm uses
    xorg-xinit
    xorg-server
    xorg-xrandr
    xorg-xset
    xorg-xinput
    xorg-xdpyinfo
    xorg-xprop
    xorg-xkill
    adwaita-cursors
    adwaita-icon-theme

    # --- Shell & terminal ---
    fish
    kitty
    starship
    fzf
    git
    tmux
    fisher
    neovim                  # nvim/ is managed by chezmoi; this is the binary
    jq                      # parsed by i3/scripts/smart-kill.sh (mod+q)
    man-db
    man-pages

    # --- Fonts ---
    ttf-jetbrains-mono-nerd

    # --- Status bar / panels ---
    polybar
    i3blocks
    i3status
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
    eza
    bat
    fd
    ripgrep
    zoxide

    # --- Hardware / desktop integration ---
    blueman                 # bluetooth tray + applet
    bluez-utils
    easyeffects             # audio effects (pipewire)
    gst-plugin-pipewire
    libva-intel-driver
    intel-media-driver
    inotify-tools
    gvfs-mtp                # phone file access over MTP

    # --- Optional (uncomment to install) ---
    # brightnessctl           # backlight; skip on desktops without one
    # upower                  # power/battery reporting
    # betterlockscreen        # lock screen bound to mod+shift+x
    # variety                 # wallpaper rotation
    # nm-applet               # network tray applet
    # alacritty               # alternative terminal
    # flatpak                 # Flatpak apps
    # cava                    # audio visualiser
    # flameshot               # screenshot tool
    # htop
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