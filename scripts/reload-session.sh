#!/bin/bash

# Reload waybar (re-reads config without restart)
pkill -SIGUSR2 waybar

# Reload niri config
niri msg action reload-config

# Restart swaync (no reload signal, must restart)
pkill -f swaync
sleep 0.3
swaync &

# Restart cava
pkill -USR1 cava
