#!/bin/bash

CONFIG_DIR="$HOME/.config/rofi"
RASI_THEME="$CONFIG_DIR/system-beautiful.rasi"
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
        -theme "$RASI_THEME" \
        -theme-str "window {width: 400;} listview {lines: 2;}")
    [[ "$confirm" == *"Yes"* ]]
}

# Build the menu
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
󰉋  Open Wallpapers
󰒓  Settings
󰓏  System Info
EOF
}

selected=$(menu | rofi -dmenu -p "    " -i -theme "$RASI_THEME" \
    -theme-str "window {width: 550;} listview {lines: 11;}")

# Strip leading icon characters for matching
selected_clean=$(echo "$selected" | sed 's/^[^a-zA-Z]*//')

case "$selected_clean" in
    "Random Wallpaper"*)
        # Spawn via niri to get full session environment (same as Mod+Q)
        niri msg action spawn -- bash -c '
            wallpaper=$(find "$HOME/wallpapers" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) | shuf -n 1)
            if [[ -n "$wallpaper" ]]; then
                echo "$wallpaper" > "$HOME/scripts/current-path.txt"
                cp "$wallpaper" "$HOME/scripts/current-image.jpg"
                matugen image "$wallpaper" --prefer saturation
                pkill -f swaync; sleep 0.3; swaync &
                notify-send "Wallpaper changed" "$(basename "$wallpaper")"
            fi
        '
        ;;
    "Select Wallpaper"*)
        # Spawn via niri to get full session environment (same as Mod+Q)
        niri msg action spawn -- "$HOME/scripts/wallpaper-pick.sh"
        ;;
    "Lock Screen"*)
        niri msg action spawn -- hyprlock
        ;;
    "Reboot System"*)
        if confirm_action "Reboot"; then
            notify "Rebooting..." "System will reboot in 3 seconds" "critical"
            sleep 3
            systemctl reboot
        fi
        ;;
    "Power Off"*)
        if confirm_action "Power Off"; then
            notify "Shutting down..." "System will power off in 3 seconds" "critical"
            sleep 3
            systemctl poweroff
        fi
        ;;
    "Suspend"*)
        if confirm_action "Suspend"; then
            systemctl suspend
        fi
        ;;
    "Log Out"*)
        if confirm_action "Log Out"; then
            niri msg action quit
        fi
        ;;
    "Reload Config"*)
        niri msg action reload-config
        pkill -SIGUSR2 waybar
        notify "Config reloaded" "" "low"
        ;;
    "Apply Matugen Theme"*)
        if [[ -f "$CURRENT_WALLPAPER" ]]; then
            wallpaper=$(cat "$CURRENT_WALLPAPER")
            if [[ -f "$wallpaper" ]] && check_command "matugen"; then
                niri msg action spawn -- bash -c "
                    matugen image \"$wallpaper\" --prefer saturation
                    pkill -f swaync; sleep 0.3; swaync &
                "
                notify "Matugen" "Theme applied" "low"
            else
                notify "Error" "Wallpaper not found or matugen missing" "critical"
            fi
        else
            notify "Error" "No saved wallpaper path" "critical"
        fi
        ;;
    "Open Wallpapers"*)
        niri msg action spawn -- nautilus "$WALLPAPER_DIR"
        ;;
    "Settings"*)
        niri msg action spawn -- nwg-look
        ;;
    "System Info"*)
        niri msg action spawn -- kitty -e btop
        ;;
esac
