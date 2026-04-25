#!/bin/bash

PID_FILE="/tmp/wf-recorder-video.pid"
SAVE_DIR="$HOME/Videos/Recordings"
mkdir -p "$SAVE_DIR"

# Stop if already recording
if [[ -f "$PID_FILE" ]]; then
    PID=$(cat "$PID_FILE")
    kill -INT "$PID" 2>/dev/null
    wait "$PID" 2>/dev/null
    rm -f "$PID_FILE"

    # Find latest recording and extract thumbnail
    latest=$(ls -t "$SAVE_DIR"/*.mp4 2>/dev/null | head -1)
    if [[ -n "$latest" ]]; then
        echo "file://$latest" | setsid wl-copy --type text/uri-list &

        thumb="/tmp/record-thumb.jpg"
        ffmpeg -y -i "$latest" -vframes 1 -q:v 2 "$thumb" &>/dev/null
        notify-send \
            -h boolean:transient:true \
            -h "string:image-path:$thumb" \
            "Recording stopped & copied" \
            "$(basename "$latest")"
    fi
    exit 0
fi

# Slurp colors from Matugen theme
primary=$(grep "@define-color primary " ~/.config/waybar/colors.css | grep -oP '#\w+')
border="${primary#\#}ee"

region=$(slurp -b "00000066" -c "$border" -s "00000000" -w 2 2>/dev/null) || exit 0

output="$SAVE_DIR/$(date '+%Y-%m-%d_%H-%M-%S').mp4"

# Hardware accelerated recording
wf-recorder -g "$region" -f "$output" \
    --audio-backend=pipewire \
    -c h264_vaapi -d /dev/dri/renderD128 \
    -p qp=18 -r 60 &

echo $! > "$PID_FILE"

notify-send \
    -h boolean:transient:true \
    "Recording started" \
    "Press Mod+Delete to stop"
