#!/bin/bash

# Kill existing waybar instance before starting a new one
pkill waybar
sleep 0.2
waybar &
