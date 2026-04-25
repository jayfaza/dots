#!/bin/bash

# Clipboard history через cliphist + rofi с превью изображений

CACHE_DIR="/tmp/cliphist-previews"
mkdir -p "$CACHE_DIR"

entries=$(cliphist list 2>/dev/null)

if [[ -z "$entries" ]]; then
    notify-send "Clipboard" "History is empty"
    exit 0
fi

# Временный файл для rofi input (нулевые байты через файл, не через pipe-строки)
TMP_INPUT=$(mktemp)

while IFS=$'\t' read -r id label; do
    if [[ "$label" == \[\[*\]\] ]]; then
        # Парсим: [[ binary data 62 KiB png 675x544 ]]
        size=$(echo "$label" | grep -oP '\d+ \w+(?= \w+ \d+x\d+)')
        fmt=$(echo "$label"  | grep -oP '(?<=KiB )\w+|(?<=MiB )\w+|(?<=B )\w+' | head -1 | tr '[:lower:]' '[:upper:]')
        res=$(echo "$label"  | grep -oP '\d+x\d+')
        display="${fmt:-Image} ${res} (${size})"

        preview="$CACHE_DIR/${id}.png"
        if [[ ! -f "$preview" ]]; then
            cliphist decode <<< "${id}"$'\t'"${label}" 2>/dev/null \
                | convert - -thumbnail 64x64^ -gravity center -extent 64x64 "$preview" 2>/dev/null \
                || rm -f "$preview"
        fi
        if [[ -f "$preview" ]]; then
            printf '%s\0icon\x1f%s\n' "${id}"$'\t'"${display}" "$preview" >> "$TMP_INPUT"
        else
            printf '%s\n' "${id}"$'\t'"${display}" >> "$TMP_INPUT"
        fi
        continue
    fi
    printf '%s\n' "${id}"$'\t'"${label}" >> "$TMP_INPUT"
done <<< "$entries"

selected=$(rofi -dmenu \
    -p "  clipboard" \
    -show-icons \
    -theme "$HOME/.config/rofi/clipboard.rasi" \
    -display-columns 2 \
    < "$TMP_INPUT" 2>/dev/null)

rm -f "$TMP_INPUT"

[[ -z "$selected" ]] && exit 0

cliphist decode <<< "$selected" | wl-copy
