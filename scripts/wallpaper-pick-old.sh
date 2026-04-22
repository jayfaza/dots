#!/bin/bash

dir="$HOME/wallpapers"
cd "$dir" || exit

wallpaper="none is selected"

selectpic() {
  wallpaper=$(for img in "$dir"/*; do
    echo -en "$(basename "$img")\0icon\x1f$img\n"
  done | rofi -dmenu -show-icons -p "paper:" -theme /home/jayfaza/.config/rofi/wallpaper-test.rasi)

  if [[ -z "$wallpaper" ]]; then
    exit
  else
    set_wall
  fi
}


set_wall() {
  echo "$wallpaper" 
  if [[ "$wallpaper" == "rand" ]]; then
	mapfile -t < <(find "$dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \))
	wallpaper=$(basename "${images[RANDOM % ${#images[@]}]}")
  fi
  echo "$dir/$wallpaper" > ~/scripts/current-path.txt
  cp -r $dir/$wallpaper ~/scripts/current-image.jpg
  WALLPAPER='$wallpaper'
  matugen image "$dir/$wallpaper"
  cp "$dir/$wallpaper" ~/.config/hypr/current/
}


selectpic
bash "/home/jayfaza/scripts/reload.sh"
notify-send "Wallpaper changed :>"
