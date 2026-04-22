#!/bin/bash

# Take a screenshot with region selection using grimblast (niri-compatible)
# Saves to ~/screenshots/ with timestamp filename

output="$HOME/screenshots/$(date '+%Y-%m-%d_%H-%M-%S').png"

if command -v grimblast &>/dev/null; then
    grimblast save area "$output"
elif command -v grim &>/dev/null && command -v slurp &>/dev/null; then
    grim -g "$(slurp)" "$output"
else
    # Fallback: full screen
    grim "$output"
fi

notify-send "Screenshot saved" "$(basename "$output")"
