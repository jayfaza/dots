#!/bin/bash

# OCR: выделить регион → препроцессинг → tesseract → буфер
# Автоматически выбирает PSM режим по размеру региона

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

# Определяем размер региона из строки "X,Y WxH"
region_size=$(echo "$region" | grep -oP '\d+x\d+')
width=$(echo "$region_size"  | cut -dx -f1)
height=$(echo "$region_size" | cut -dx -f2)

# Выбираем PSM по размеру:
#   одно слово  : w<120 и h<60
#   одна строка : h<80
#   блок текста : всё остальное
if [[ "$width" -lt 120 && "$height" -lt 60 ]]; then
    psm_order=(8 7 6)    # single_word → single_line → single_block
elif [[ "$height" -lt 80 ]]; then
    psm_order=(7 8 6)    # single_line → single_word → single_block
else
    psm_order=(6 3 11)   # single_block → auto → sparse_text
fi

# Препроцессинг: апскейл 4x для маленьких регионов, 3x для больших
if [[ "$width" -lt 200 || "$height" -lt 80 ]]; then
    scale="400%"
else
    scale="300%"
fi

convert "$TMP_IMG" \
    -resize "$scale" \
    -colorspace Gray \
    -contrast-stretch 0.15x0.15% \
    -sharpen 0x1 \
    "$TMP_ENHANCED" 2>/dev/null

# Пробуем PSM режимы по очереди пока не получим текст
try_ocr() {
    local img="$1"
    local psm="$2"
    tesseract "$img" "$TMP_TXT" -l eng+rus --psm "$psm" --oem 1 2>/dev/null
    local result
    result=$(sed '/^[[:space:]]*$/d' "${TMP_TXT}.txt" 2>/dev/null | sed 's/[[:space:]]*$//')
    rm -f "${TMP_TXT}.txt"
    printf '%s' "$result"
}

text=""
for psm in "${psm_order[@]}"; do
    text=$(try_ocr "$TMP_ENHANCED" "$psm")
    [[ -n "$text" ]] && break
done

# Если не нашли — пробуем инверт (светлый текст на тёмном фоне)
if [[ -z "$text" ]]; then
    convert "$TMP_IMG" \
        -resize "$scale" \
        -colorspace Gray \
        -negate \
        -contrast-stretch 0.15x0.15% \
        -sharpen 0x1 \
        "/tmp/ocr-inverted.png" 2>/dev/null

    for psm in "${psm_order[@]}"; do
        text=$(try_ocr "/tmp/ocr-inverted.png" "$psm")
        [[ -n "$text" ]] && break
    done

    rm -f "/tmp/ocr-inverted.png"
fi

rm -f "$TMP_ENHANCED"

if [[ -z "$text" ]]; then
    notify-send -u normal "OCR" "No text detected"
    exit 0
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
