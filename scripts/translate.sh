#!/bin/bash

# Translate: текст из буфера → перевод → скопировать, показать уведомление
# Автоматически определяет язык: если en → ru, иначе → en

# Взять текст из буфера
text=$(wl-paste --no-newline 2>/dev/null)

if [[ -z "$text" ]]; then
    notify-send -u normal "Translate" "Clipboard is empty"
    exit 0
fi

# Ограничить длину
if [[ ${#text} -gt 2000 ]]; then
    text="${text:0:2000}"
fi

# Определить язык через Name строку (без ANSI мусора)
src_name=$(echo "$text" | trans -no-ansi -identify 2>/dev/null | grep "^Name" | awk '{print $2}')

if [[ "$src_name" == "English" ]]; then
    target="ru"
    target_label="RU"
    src_label="EN"
else
    target="en"
    target_label="EN"
    src_label="${src_name:-??}"
fi

# Перевести
result=$(echo "$text" | trans -no-ansi -brief ":${target}" 2>/dev/null)

if [[ -z "$result" ]]; then
    notify-send -u critical "Translate" "Translation failed (no internet?)"
    exit 1
fi

# Скопировать перевод в буфер
printf '%s' "$result" | wl-copy

# Превью для уведомления
orig_preview=$(printf '%s' "$text" | head -c 60)
[[ ${#text} -gt 60 ]] && orig_preview="${orig_preview}…"

result_preview=$(printf '%s' "$result" | head -c 120)
[[ ${#result} -gt 120 ]] && result_preview="${result_preview}…"

notify-send \
    -h boolean:transient:true \
    "${src_label} → ${target_label}" \
    "${orig_preview}
${result_preview}"

# Добавить в cliphist если установлен
if command -v cliphist &>/dev/null; then
    printf '%s' "$result" | cliphist store 2>/dev/null
fi
