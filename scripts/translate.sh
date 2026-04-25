#!/bin/bash

# Translate: текст из буфера → прямой Google API
# Стратегия: запускаем en→ru и ru→en параллельно, берём нужный по определённому языку

text=$(wl-paste --no-newline 2>/dev/null)

if [[ -z "$text" ]]; then
    notify-send -u normal "Translate" "Clipboard is empty"
    exit 0
fi

[[ ${#text} -gt 2000 ]] && text="${text:0:2000}"

encoded=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.stdin.read()))" <<< "$text")

TMP_EN=$(mktemp)
TMP_RU=$(mktemp)

# Два запроса параллельно: auto→en (даёт язык источника) и auto→ru
curl -sL --max-time 5 \
    "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=en&dt=t&dt=ld&q=${encoded}" \
    -o "$TMP_EN" 2>/dev/null &
PID_EN=$!

curl -sL --max-time 5 \
    "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=ru&dt=t&q=${encoded}" \
    -o "$TMP_RU" 2>/dev/null &
PID_RU=$!

wait $PID_EN $PID_RU

# Парсим язык источника из en-запроса
src_lang=$(python3 -c "import sys,json; d=json.load(sys.stdin); print(d[2])" < "$TMP_EN" 2>/dev/null)

if [[ "$src_lang" == "en" ]]; then
    result=$(python3 -c "import sys,json; d=json.load(sys.stdin); print(''.join(x[0] for x in d[0] if x[0]))" < "$TMP_RU" 2>/dev/null)
    src_label="EN"; target="RU"
else
    result=$(python3 -c "import sys,json; d=json.load(sys.stdin); print(''.join(x[0] for x in d[0] if x[0]))" < "$TMP_EN" 2>/dev/null)
    src_label="${src_lang^^}"; target="EN"
fi

rm -f "$TMP_EN" "$TMP_RU"

if [[ -z "$result" ]]; then
    notify-send -u critical "Translate" "Failed (no internet?)"
    exit 1
fi

printf '%s' "$result" | wl-copy
command -v cliphist &>/dev/null && printf '%s' "$result" | cliphist store 2>/dev/null

title="${src_label} → ${target}"

# Короткий результат — обычное уведомление
if [[ ${#result} -le 80 ]]; then
    notify-send -h boolean:transient:true "$title" "$result"
    exit 0
fi

# Длинный — rofi popup с авторазмером по высоте
# Оригинал и перевод построчно через rofi listview
{
    # Оригинал серым цветом (разбиваем по ~60 символов)
    printf '%s' "$text" | fold -s -w 60 | while IFS= read -r line; do
        printf '  %s\n' "$line"
    done
    printf '\n'
    # Перевод
    printf '%s' "$result" | fold -s -w 60 | while IFS= read -r line; do
        printf '%s\n' "$line"
    done
} | rofi -dmenu \
    -p "" \
    -mesg "$title" \
    -no-custom \
    -theme "$HOME/.config/rofi/translate.rasi" \
    -selected-row 0 \
    2>/dev/null

exit 0
