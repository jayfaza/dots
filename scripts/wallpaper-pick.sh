#!/bin/bash

dir="$HOME/wallpapers"

# Show rofi picker with wallpaper previews (shuffled)
selectpic() {
    mapfile -t images < <(find "$dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" \) | sort)

    if [[ ${#images[@]} -eq 0 ]]; then
        notify-send "Error" "No images found in $dir"
        exit 1
    fi

    # Shuffle the list
    mapfile -t shuffled < <(shuf -e "${images[@]}")

    wallpaper=$(for img in "${shuffled[@]}"; do
        printf '%s\0icon\x1f%s\n' "$(basename "$img")" "$img"
    done | rofi -dmenu -show-icons -p "wallpaper:" \
        -theme "$HOME/.config/rofi/wallpaper-test.rasi" -i)

    if [[ -z "$wallpaper" ]]; then
        exit 0
    fi

    set_wall
}

set_wall() {
    # Find the full path by filename
    local selected_file
    selected_file=$(find "$dir" -name "$wallpaper" -type f | head -n 1)

    if [[ -z "$selected_file" ]]; then
        notify-send "Error" "File not found: $wallpaper"
        exit 1
    fi

    # Save current wallpaper path and a copy for previews
    echo "$selected_file" > "$HOME/scripts/current-path.txt"
    cp "$selected_file" "$HOME/scripts/current-image.jpg"

    # Apply via matugen — handles wallpaper setting + color generation
    matugen image "$selected_file" --prefer saturation

    # Restart swaync to apply new theme (matugen doesn't handle this in 4.1.0)
    pkill -f swaync; sleep 0.3; swaync &
    sleep 1

    notify-send \
        -h boolean:transient:true \
        -h "string:image-path:$selected_file" \
        "Wallpaper changed" \
        "$(basename "$selected_file")"
}

selectpic
