#!/bin/bash

# Вспышка экрана перед скриншотом
niri msg action do-screen-transition --delay-ms 16

output="$HOME/screenshots/$(date '+%Y-%m-%d_%H-%M-%S').png"
mkdir -p "$HOME/screenshots"

# Colors: background=dark overlay, selection=transparent, border=primary
primary=$(grep "@define-color primary " ~/.config/waybar/colors.css | grep -oP '#\w+')
border="${primary#\#}ee"
bg="00000066"
sel="00000000"

region=$(slurp -b "$bg" -c "$border" -s "$sel" -w 2 2>/dev/null) || exit 0

# Обрезаем рамку (2px с каждой стороны)
rx=$(echo "$region" | grep -oP '^\d+')
ry=$(echo "$region" | grep -oP ',\d+' | tr -d ',')
rw=$(echo "$region" | grep -oP '\d+x' | tr -d 'x')
rh=$(echo "$region" | grep -oP 'x\d+$' | tr -d 'x')
pad=2
rx=$((rx + pad)); ry=$((ry + pad))
rw=$((rw - pad * 2)); rh=$((rh - pad * 2))
[[ $rw -lt 1 ]] && rw=1
[[ $rh -lt 1 ]] && rh=1

grim -g "${rx},${ry} ${rw}x${rh}" "$output" || exit 1

wl-copy < "$output"

notify-send \
    -h boolean:transient:true \
    -h "string:image-path:$output" \
    "Screenshot captured" \
    "Saved & copied to clipboard"
