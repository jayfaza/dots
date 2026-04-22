#!/bin/bash

CONFIG_DIR="$HOME/.config/rofi"
RASI_THEME="$CONFIG_DIR/system.rasi"
WALLPAPER_DIR="$HOME/wallpapers"
CURRENT_WALLPAPER="$HOME/scripts/current-path.txt"

# Check if a command exists
check_command() {
    command -v "$1" &>/dev/null
}

# Send desktop notification
notify() {
    local title="$1"
    local message="$2"
    local urgency="${3:-normal}"
    check_command "notify-send" && notify-send -u "$urgency" "$title" "$message"
}

# Show a Yes/No confirmation dialog via rofi
confirm_action() {
    local action="$1"
    local confirm
    confirm=$(echo -e "󰅖  No\n󰄬  Yes" | rofi -dmenu \
        -p "  ⚠️  $action?  " -i \
        -theme "$CONFIG_DIR/system-buatiful.rasi" \
        -theme-str "window {width: 400;} listview {lines: 2;}")
    [[ "$confirm" == *"Yes"* ]]
}

# Pick a random wallpaper and apply via matugen
set_wallpaper() {
    if [[ ! -d "$WALLPAPER_DIR" ]]; then
        notify "Error" "Wallpaper folder not found: $WALLPAPER_DIR" "critical"
        return 1
    fi

    local wallpaper
    wallpaper=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) | shuf -n 1)

    if [[ -z "$wallpaper" ]]; then
        notify "Error" "No images found in $WALLPAPER_DIR" "critical"
        return 1
    fi

    echo "$wallpaper" > "$CURRENT_WALLPAPER"
    cp "$wallpaper" "$HOME/scripts/current-image.jpg"

    if check_command "matugen"; then
        # matugen handles wallpaper setting + color generation via its own config
        matugen image "$wallpaper" --prefer saturation
        notify "Wallpaper changed" "$(basename "$wallpaper")" "low"
    else
        notify "Error" "matugen not installed" "critical"
        return 1
    fi
}

# Pick a specific wallpaper from folder via rofi
select_wallpaper() {
    if [[ ! -d "$WALLPAPER_DIR" ]]; then
        notify "Error" "Wallpaper folder not found: $WALLPAPER_DIR" "critical"
        return 1
    fi

    local wallpapers
    wallpapers=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -printf "%f\n" | sort)

    if [[ -z "$wallpapers" ]]; then
        notify "Error" "No images found in $WALLPAPER_DIR" "critical"
        return 1
    fi

    local selected
    selected=$(echo "$wallpapers" | rofi -dmenu -p "  Select Wallpaper  " -i \
        -theme "$CONFIG_DIR/system-buatiful.rasi" \
        -theme-str "window {width: 600;} listview {lines: 10;}")

    if [[ -n "$selected" ]]; then
        local wallpaper_path="$WALLPAPER_DIR/$selected"
        echo "$wallpaper_path" > "$CURRENT_WALLPAPER"
        cp "$wallpaper_path" "$HOME/scripts/current-image.jpg"

        if check_command "matugen"; then
            matugen image "$wallpaper_path" --prefer saturation
            notify "Wallpaper changed" "$selected" "low"
        else
            notify "Error" "matugen not installed" "critical"
        fi
    fi
}

# Lock screen
lock_screen() {
    if check_command "hyprlock"; then
        hyprlock
    elif check_command "swaylock"; then
        swaylock -f -c 2e3440
    else
        notify "Error" "Install hyprlock or swaylock" "critical"
    fi
}

# Reload niri config and waybar
reload_config() {
    niri msg action reload-config
    pkill -SIGUSR2 waybar
    notify "Config reloaded" "" "low"
}

# Re-apply matugen theme from saved wallpaper
apply_matugen_theme() {
    if [[ -f "$CURRENT_WALLPAPER" ]]; then
        local wallpaper
        wallpaper=$(cat "$CURRENT_WALLPAPER")
        if [[ -f "$wallpaper" ]] && check_command "matugen"; then
            matugen image "$wallpaper" --prefer saturation
            notify "Matugen" "Theme applied" "low"
        else
            notify "Error" "Wallpaper not found or matugen missing" "critical"
        fi
    else
        notify "Error" "No saved wallpaper path" "critical"
    fi
}

# Build menu
menu() {
    cat << EOF
󰸉  Random Wallpaper
󰋩  Select Wallpaper
󰤁  Lock Screen
  Reboot System
⏻  Power Off
󰒳  Suspend
󰍃  Log Out
󰔄  Reload Config
󰌌  Apply Matugen Theme
󰉋  Open Wallpapers Folder
EOF
}

selected=$(menu | rofi -dmenu -p "    " -i -theme "$RASI_THEME")

case "$selected" in
    *"Random Wallpaper"*)
        set_wallpaper
        ;;
    *"Select Wallpaper"*)
        select_wallpaper
        ;;
    *"Lock Screen"*)
        lock_screen
        ;;
    *"Reboot System"*)
        if confirm_action "Reboot"; then
            notify "Rebooting..." "System will reboot in 3 seconds" "critical"
            sleep 3
            systemctl reboot
        fi
        ;;
    *"Power Off"*)
        if confirm_action "Power Off"; then
            notify "Shutting down..." "System will power off in 3 seconds" "critical"
            sleep 3
            systemctl poweroff
        fi
        ;;
    *"Suspend"*)
        if confirm_action "Suspend"; then
            systemctl suspend
        fi
        ;;
    *"Log Out"*)
        if confirm_action "Log Out"; then
            niri msg action quit
        fi
        ;;
    *"Reload Config"*)
        reload_config
        ;;
    *"Apply Matugen Theme"*)
        apply_matugen_theme
        ;;
    *"Open Wallpapers Folder"*)
        nautilus "$WALLPAPER_DIR"
        ;;
esac
