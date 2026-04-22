#!/bin/bash

# Immediate power off after 3 second delay (called from waybar power button)
sleep 3
systemctl poweroff
