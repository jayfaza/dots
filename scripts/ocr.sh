#!/bin/bash

# OCR: выделить регион → препроцессинг → tesseract → буфер
# Препроцессинг: апскейл 3x + grayscale + contrast stretch → точность и скорость выше

TMP_IMG="/tmp/ocr-capture.png"
TMP_ENHANCED="/tmp/ocr-enhanced.png"
TMP_TXT="/tmp/ocr-output"

primary=$(grep "@define-color primary " ~/.config/waybar/colors.css | grep -oP '#\w+')
border="${primary#\#}ee"

region=$(slurp -b "00000066" -c "$border" -s "00000000" -w 2 2>/dev/null) || exit 0

grim -g "$region" "$TMP_IMG" || {
    notify-send -u critical "OCR" "Failed to capture screen"
    exit 1
}

# Препроцессинг для лучшего распознавания:
# 1. Апскейл в 3x — tesseract работает лучше с крупным текстом
# 2. Grayscale — убирает шум цвета
# 3. contrast-stretch — усиливает контраст текст/фон
# 4. Sharpen — делает края букв чёткими
convert "$TMP_IMG" \
    -resize 300% \
    -colorspace Gray \
    -contrast-stretch 0.15x0.15% \
    -sharpen 0x1 \
    "$TMP_ENHANCED" 2>/dev/null

# psm 3 = автоопределение блоков (лучше для произвольного текста на экране)
# oem 1 = только LSTM (быстрее и точнее чем oem 3)
tesseract "$TMP_ENHANCED" "$TMP_TXT" -l eng+rus --psm 3 --oem 1 2>/dev/null

TXT_FILE="${TMP_TXT}.txt"

if [[ ! -f "$TXT_FILE" ]]; then
    notify-send -u critical "OCR" "Tesseract failed"
    exit 1
fi

text=$(sed '/^[[:space:]]*$/d' "$TXT_FILE" | sed 's/[[:space:]]*$//')

rm -f "$TMP_ENHANCED" "$TXT_FILE"

if [[ -z "$text" ]]; then
    # Второй шанс: если не распознало — пробуем с инвертом (светлый текст на тёмном фоне)
    convert "$TMP_IMG" \
        -resize 300% \
        -colorspace Gray \
        -negate \
        -contrast-stretch 0.15x0.15% \
        -sharpen 0x1 \
        "/tmp/ocr-inverted.png" 2>/dev/null

    tesseract "/tmp/ocr-inverted.png" "$TMP_TXT" -l eng+rus --psm 3 --oem 1 2>/dev/null
    text=$(sed '/^[[:space:]]*$/d' "${TMP_TXT}.txt" 2>/dev/null | sed 's/[[:space:]]*$//')
    rm -f "/tmp/ocr-inverted.png" "${TMP_TXT}.txt"

    if [[ -z "$text" ]]; then
        notify-send -u normal "OCR" "No text detected"
        exit 0
    fi
fi

printf '%s' "$text" | wl-copy

preview=$(printf '%s' "$text" | head -c 80)
[[ ${#text} -gt 80 ]] && preview="${preview}…"

notify-send \
    -h boolean:transient:true \
    -h "string:image-path:$TMP_IMG" \
    "OCR — copied" \
    "$preview"

command -v cliphist &>/dev/null && printf '%s' "$text" | cliphist store 2>/dev/null
