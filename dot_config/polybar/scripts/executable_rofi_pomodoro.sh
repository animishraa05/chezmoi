#!/bin/bash

# Rofi menu for Pomodoro Timer by ani
# Right-click the polybar module to open.

POMODORO="/home/ani/.config/polybar/scripts/pomodoro.sh"
STATS="/home/ani/.config/polybar/scripts/pomodoro_stats.py"
RASI="/home/ani/.config/rofi/pomodoro_menu.rasi"

OPTIONS="25 / 5\n40 / 10\n50 / 15\nCustom\nStats\nStop"

CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -config "$RASI" -p " Pomodoro")

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    Stop)
        "$POMODORO" stop
        ;;
    Custom)
        WORK=$(echo "" | rofi -dmenu -config "$RASI" -p " Work (min):" \
               -theme-str 'listview {enabled: false;} entry {placeholder: "e.g. 45";}')
        [ -z "$WORK" ] && exit 0

        # Validate: must be a positive integer
        if ! [[ "$WORK" =~ ^[0-9]+$ ]] || [ "$WORK" -le 0 ]; then
            dunstify -u normal "Pomodoro" "Invalid work duration: '$WORK'. Enter a positive number."
            exit 1
        fi

        CHILL=$(echo "" | rofi -dmenu -config "$RASI" -p " Break (min):" \
                -theme-str 'listview {enabled: false;} entry {placeholder: "e.g. 10";}')
        [ -z "$CHILL" ] && exit 0

        if ! [[ "$CHILL" =~ ^[0-9]+$ ]] || [ "$CHILL" -le 0 ]; then
            dunstify -u normal "Pomodoro" "Invalid break duration: '$CHILL'. Enter a positive number."
            exit 1
        fi

        "$POMODORO" start "$WORK" "$CHILL"
        dunstify -u low "Pomodoro" "Started: ${WORK}m work / ${CHILL}m break"
        ;;
    Stats)
        kitty --title "Pomodoro Stats" -e python3 "$STATS" &
        ;;
    *)
        # Parse preset "WORK / CHILL"
        WORK=$(echo "$CHOICE" | cut -d'/' -f1 | tr -d ' ')
        CHILL=$(echo "$CHOICE" | cut -d'/' -f2 | tr -d ' ')
        if [[ "$WORK" =~ ^[0-9]+$ ]] && [[ "$CHILL" =~ ^[0-9]+$ ]]; then
            "$POMODORO" start "$WORK" "$CHILL"
            dunstify -u low "Pomodoro" "Started: ${WORK}m work / ${CHILL}m break"
        fi
        ;;
esac
