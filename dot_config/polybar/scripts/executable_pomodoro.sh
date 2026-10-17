#!/bin/bash

# ─────────────────────────────
# POMODORO TIMER by ani (extended)
# ─────────────────────────────

STATE_FILE="/tmp/polybar_pomodoro_state"
START_TIME_FILE="/tmp/polybar_pomodoro_start_time"
PAUSED_FILE="/tmp/polybar_pomodoro_paused"
DURATIONS_FILE="/tmp/polybar_pomodoro_durations"
LOG_LOCK="/tmp/polybar_pomodoro_logged"

# Path to the sound file to play upon completion
SOUND_FILE="/home/ani/go/pkg/mod/github.com/gdamore/tcell/v2@v2.8.1/webfiles/beep.wav"

LOG_FILE="$HOME/.local/share/pomodoro_history.csv"

DEFAULT_WORK=2400   # 40 * 60
DEFAULT_CHILL=1200  # 20 * 60

# Function to play a sound for 15 seconds
play_sound() {
    if command -v paplay >/dev/null && [ -f "$1" ]; then
        (paplay "$1" &
        PLAYER_PID=$!
        sleep 15
        kill "$PLAYER_PID" 2>/dev/null) &
    fi
}

# Log a work session (args: elapsed_seconds)
log_session() {
    local elapsed="$1"
    [ "$elapsed" -le 0 ] && return  # don't log 0-second sessions
    mkdir -p "$(dirname "$LOG_FILE")"
    echo "$(date -Iseconds),$elapsed,work" >> "$LOG_FILE"
}

# Save partial work session if currently in work state
save_partial_if_work() {
    if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "work" ]; then
        if [ -f "$START_TIME_FILE" ]; then
            local start elapsed
            start=$(cat "$START_TIME_FILE")
            if [ -f "$PAUSED_FILE" ]; then
                elapsed=$(cat "$PAUSED_FILE")
            else
                elapsed=$(( $(date +%s) - start ))
            fi
            log_session "$elapsed"
        fi
    fi
}

# Handle input arguments
case "$1" in
    start)
        # Validate: both args must be positive integers
        if ! [[ "${2}" =~ ^[0-9]+$ ]] || [ "${2}" -le 0 ] || \
           ! [[ "${3}" =~ ^[0-9]+$ ]] || [ "${3}" -le 0 ]; then
            exit 1
        fi
        # If a session is already running (work state), save partial before restarting
        save_partial_if_work
        WORK_DURATION=${2}
        CHILL_DURATION=${3}
        echo "$((WORK_DURATION * 60)) $((CHILL_DURATION * 60))" > "$DURATIONS_FILE"
        echo "work" > "$STATE_FILE"
        date +%s > "$START_TIME_FILE"
        rm -f "$PAUSED_FILE" "$LOG_LOCK"
        exit 0
        ;;
    toggle)
        if [ ! -f "$STATE_FILE" ]; then
            # Not running, so start with default durations
            echo "work" > "$STATE_FILE"
            date +%s > "$START_TIME_FILE"
            echo "$DEFAULT_WORK $DEFAULT_CHILL" > "$DURATIONS_FILE"
            rm -f "$PAUSED_FILE" "$LOG_LOCK"
        elif [ -f "$PAUSED_FILE" ]; then
            # Resuming from pause
            PAUSED_DURATION=$(cat "$PAUSED_FILE")
            NEW_START=$(( $(date +%s) - PAUSED_DURATION ))
            echo "$NEW_START" > "$START_TIME_FILE"
            rm -f "$PAUSED_FILE"
        else
            # Pausing
            START_TIME=$(cat "$START_TIME_FILE")
            NOW=$(date +%s)
            echo $((NOW - START_TIME)) > "$PAUSED_FILE"
        fi
        exit 0
        ;;
    stop)
        save_partial_if_work
        rm -f "$STATE_FILE" "$START_TIME_FILE" "$PAUSED_FILE" "$DURATIONS_FILE" "$LOG_LOCK"
        exit 0
        ;;
esac

# Load durations
if [ -f "$DURATIONS_FILE" ]; then
    read WORK_DURATION CHILL_DURATION < "$DURATIONS_FILE"
else
    WORK_DURATION=$DEFAULT_WORK
    CHILL_DURATION=$DEFAULT_CHILL
fi

# If state files don't exist, don't display anything
if [ ! -f "$STATE_FILE" ] || [ ! -s "$STATE_FILE" ] || [ ! -f "$START_TIME_FILE" ] || [ ! -s "$START_TIME_FILE" ]; then
    echo " Start"
    exit 0
fi

# Display pause state
if [ -f "$PAUSED_FILE" ]; then
    echo " PAUSED"
    exit 0
fi

# Read state and calculate
CURRENT_STATE=$(cat "$STATE_FILE")
START_TIME=$(cat "$START_TIME_FILE")
CURRENT_TIME=$(date +%s)
ELAPSED_TIME=$((CURRENT_TIME - START_TIME))

if [ "$CURRENT_STATE" = "work" ]; then
    REMAINING_TIME=$((WORK_DURATION - ELAPSED_TIME))
    if [ "$REMAINING_TIME" -le 0 ]; then
        # Use a lock file to prevent logging more than once per session transition
        if [ ! -f "$LOG_LOCK" ]; then
            log_session "$WORK_DURATION"
            touch "$LOG_LOCK"
        fi
        echo "chill" > "$STATE_FILE"
        date +%s > "$START_TIME_FILE"
        rm -f "$LOG_LOCK"
        REMAINING_TIME=$CHILL_DURATION
        CURRENT_STATE="chill"
        dunstify -u critical "Pomodoro" "Work is done, now chill."
        play_sound "$SOUND_FILE"
    fi
elif [ "$CURRENT_STATE" = "chill" ]; then
    REMAINING_TIME=$((CHILL_DURATION - ELAPSED_TIME))
    if [ "$REMAINING_TIME" -le 0 ]; then
        echo "work" > "$STATE_FILE"
        date +%s > "$START_TIME_FILE"
        rm -f "$LOG_LOCK"
        REMAINING_TIME=$WORK_DURATION
        CURRENT_STATE="work"
        dunstify -u critical "Pomodoro" "Chill done, get back to work."
        play_sound "$SOUND_FILE"
    fi
fi

# Format time
[ "$REMAINING_TIME" -lt 0 ] && REMAINING_TIME=0
MINUTES=$((REMAINING_TIME / 60))
SECONDS=$((REMAINING_TIME % 60))
printf -v FORMATTED_SECONDS "%02d" "$SECONDS"

# Output
if [ "$CURRENT_STATE" = "work" ]; then
    echo " WORK: ${MINUTES}:${FORMATTED_SECONDS}"
else
    echo " CHILL: ${MINUTES}:${FORMATTED_SECONDS}"
fi
