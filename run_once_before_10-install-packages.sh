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

    # --- Desktop integration ---
    brightnessctl           # backlight; harmless on machines without one
    upower                  # power/battery reporting
    network-manager-applet  # NOT "nm-applet" - that is the binary name
    variety                 # wallpaper rotation
    htop

    # --- Optional extras ---
    alacritty               # alternative terminal
    flatpak                 # Flatpak apps
    cava                    # audio visualiser
    flameshot               # screenshot tool
)

# --- AUR-only packages ---
# Not in the official repos, so they cannot go in the list above.
# betterlockscreen is bound to mod+shift+x in i3/keymaps.conf.
AUR_PACKAGES=(
    betterlockscreen
)

missing=()
for pkg in "${PACKAGES[@]}"; do
    pacman -Qi "$pkg" &>/dev/null || missing+=("$pkg")
done

if [[ ${#missing[@]} -gt 0 ]]; then
    echo "--> installing ${#missing[@]} package(s) from the official repos:"
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
else
    echo "--> all official-repo packages already installed"
fi

# --- AUR ---
# Separate because pacman cannot resolve these. Never fatal: a machine
# without an AUR helper should still end up with a working desktop.
aur_missing=()
for pkg in "${AUR_PACKAGES[@]}"; do
    pacman -Qi "$pkg" &>/dev/null || aur_missing+=("$pkg")
done

if [[ ${#aur_missing[@]} -eq 0 ]]; then
    echo "--> all AUR packages already installed"
elif command -v yay &>/dev/null; then
    echo "--> installing AUR package(s): ${aur_missing[*]}"
    yay -S --needed --noconfirm "${aur_missing[@]}" || \
        echo ">>> yay failed for: ${aur_missing[*]} (continuing)" >&2
elif command -v paru &>/dev/null; then
    echo "--> installing AUR package(s): ${aur_missing[*]}"
    paru -S --needed --noconfirm "${aur_missing[@]}" || \
        echo ">>> paru failed for: ${aur_missing[*]} (continuing)" >&2
else
    echo ">>> AUR packages need installing: ${aur_missing[*]}" >&2
    echo ">>> no AUR helper found. Install yay or paru, then re-run:" >&2
    echo ">>>     sudo pacman -S --needed ${aur_missing[*]}" >&2
fi

echo "--> package install complete"