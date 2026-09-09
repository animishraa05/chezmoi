#!/usr/bin/env bash

# Wallpaper Picker using Rofi
# Integrated with Variety

WALLPAPER_DIR="/home/ani/.config/variety/Downloaded"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Wallpaper Picker" "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

# Get list of wallpapers
WALLPAPERS=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \))

if [ -z "$WALLPAPERS" ]; then
    notify-send "Wallpaper Picker" "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Build a list with icon paths for Rofi
ROFI_INPUT=""
while IFS= read -r wp; do
    if [ -n "$wp" ]; then
        name=$(basename "$wp")
        ROFI_INPUT+="${name}\0icon\x1f${wp}\n"
    fi
done <<< "$WALLPAPERS"

CHOICE=$(echo -en "$ROFI_INPUT" | rofi -dmenu -show-icons -config ~/.config/rofi/wallpaper_picker.rasi -p "Wallpaper")

if [ -n "$CHOICE" ]; then
    FULL_PATH=$(find "$WALLPAPER_DIR" -name "$CHOICE" | head -n 1)
    if [ -n "$FULL_PATH" ]; then
        # Set wallpaper using variety if possible, otherwise use xsetbg or similar
        variety --set="$FULL_PATH"
        notify-send "Wallpaper Picker" "Wallpaper set to $CHOICE"
    fi
fi
