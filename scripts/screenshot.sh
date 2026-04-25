#!/bin/bash

output="$HOME/screenshots/$(date '+%Y-%m-%d_%H-%M-%S').png"
mkdir -p "$HOME/screenshots"

# Colors: background=dark overlay, selection=transparent, border=primary
primary=$(grep "@define-color primary " ~/.config/waybar/colors.css | grep -oP '#\w+')
border="${primary#\#}ee"
bg="00000066"
sel="00000000"

region=$(slurp -b "$bg" -c "$border" -s "$sel" -w 2 2>/dev/null) || exit 0

grim -g "$region" "$output" || exit 1

wl-copy < "$output"

notify-send \
    -h boolean:transient:true \
    -h "string:image-path:$output" \
    "Screenshot captured" \
    "Saved & copied to clipboard"
