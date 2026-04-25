#!/bin/bash

# OCR: выделить регион → распознать текст → скопировать в буфер

TMP_IMG="/tmp/ocr-capture.png"
TMP_TXT="/tmp/ocr-output"

# Цвет рамки из matugen (как в screenshot.sh)
primary=$(grep "@define-color primary " ~/.config/waybar/colors.css | grep -oP '#\w+')
border="${primary#\#}ee"

# Выбрать регион
region=$(slurp -b "00000066" -c "$border" -s "00000000" -w 2 2>/dev/null) || exit 0

# Скриншот выбранного региона
grim -g "$region" "$TMP_IMG" || {
    notify-send -u critical "OCR" "Failed to capture screen"
    exit 1
}

# Распознать текст (eng+rus)
tesseract "$TMP_IMG" "$TMP_TXT" -l eng+rus --psm 6 2>/dev/null

TXT_FILE="${TMP_TXT}.txt"

if [[ ! -f "$TXT_FILE" ]]; then
    notify-send -u critical "OCR" "Tesseract failed"
    exit 1
fi

# Убрать лишние пустые строки и пробелы
text=$(sed '/^[[:space:]]*$/d' "$TXT_FILE" | sed 's/[[:space:]]*$//')

if [[ -z "$text" ]]; then
    notify-send -u normal "OCR" "No text detected"
    exit 0
fi

# Скопировать в буфер
printf '%s' "$text" | wl-copy

# Уведомление с превью текста (первые 80 символов)
preview=$(printf '%s' "$text" | head -c 80)
[[ ${#text} -gt 80 ]] && preview="${preview}…"

notify-send \
    -h boolean:transient:true \
    -h "string:image-path:$TMP_IMG" \
    "OCR — copied" \
    "$preview"

# Добавить в cliphist если установлен
if command -v cliphist &>/dev/null; then
    printf '%s' "$text" | cliphist store 2>/dev/null
fi

rm -f "$TMP_TXT.txt"
