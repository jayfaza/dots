#!/bin/bash

PID_FILE="/tmp/wf-recorder-gif.pid"
TMP_MP4="/tmp/wf-recorder-gif-tmp.mp4"
SAVE_DIR="$HOME/Videos/Recordings"
mkdir -p "$SAVE_DIR"

# Stop if already recording
if [[ -f "$PID_FILE" ]]; then
    PID=$(cat "$PID_FILE")
    kill -INT "$PID" 2>/dev/null
    wait "$PID" 2>/dev/null
    rm -f "$PID_FILE"

    output="$SAVE_DIR/$(date '+%Y-%m-%d_%H-%M-%S').gif"

    notify-send \
        -h boolean:transient:true \
        "Converting to GIF..." \
        "Please wait"

    # High-quality GIF conversion via palette
    ffmpeg -y -i "$TMP_MP4" \
        -vf "fps=20,scale=iw:ih:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=256:stats_mode=diff[p];[s1][p]paletteuse=dither=bayer" \
        "$output" &>/dev/null

    rm -f "$TMP_MP4"

    if [[ -f "$output" ]]; then
        echo "file://$output" | setsid wl-copy --type text/uri-list &

        thumb="/tmp/record-gif-thumb.jpg"
        ffmpeg -y -i "$output" -vframes 1 -q:v 2 "$thumb" &>/dev/null
        notify-send \
            -h boolean:transient:true \
            -h "string:image-path:$thumb" \
            "GIF saved & copied" \
            "$(basename "$output")"
    else
        notify-send "GIF conversion failed" "Check ffmpeg output"
    fi
    exit 0
fi

# Slurp colors from Matugen theme
primary=$(grep "@define-color primary " ~/.config/waybar/colors.css | grep -oP '#\w+')
border="${primary#\#}ee"

region=$(slurp -b "00000066" -c "$border" -s "00000000" -w 2 2>/dev/null) || exit 0

# Record to temp mp4 first (much faster than direct GIF)
wf-recorder -g "$region" -f "$TMP_MP4" \
    --audio-backend=none \
    -c libx264 -r 20 &

echo $! > "$PID_FILE"

notify-send \
    -h boolean:transient:true \
    "GIF recording started" \
    "Press Alt+Delete to stop"
