#!/usr/bin/env bash

# Power Menu - Minimal
OPTIONS="Logout\nReboot\nShutdown"

LAUNCHER="rofi -dmenu -config ~/.config/rofi/power_menu.rasi"

option=$(echo -e "$OPTIONS" | $LAUNCHER)
if [ -n "$option" ]; then
    case "$option" in
        Logout)
            i3-msg exit
            ;;
        Reboot)
            systemctl reboot
            ;;
        Shutdown)
            systemctl poweroff
            ;;
    esac
fi
