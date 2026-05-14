#!/bin/bash
BRIGHTNESSCTL=/usr/bin/brightnessctl
ROFI=/usr/bin/rofi
SLIDER=/home/crepco/.config/waybar/scripts/slider.py

CUR=$($BRIGHTNESSCTL get 2>/dev/null)
MAX=$($BRIGHTNESSCTL max 2>/dev/null)
[ -z "$CUR" ] || [ -z "$MAX" ] || [ "$MAX" = "0" ] && exit 1
PCT=$(( CUR * 100 / MAX ))

if [ "$1" = "menu" ]; then
    STATUS="󰃠  Brightness — $PCT%"
    CHOICE=$(printf "󰃠  100%%\n󰃟   80%%\n󰃞   60%%\n󰃝   40%%\n󰃛   20%%\n󰃜   10%%" | $ROFI -dmenu \
        -mesg "$STATUS" \
        -theme /home/crepco/.config/rofi/dropdown.rasi \
        -no-custom -p "")
    [ -z "$CHOICE" ] && exit 0
    case "$CHOICE" in
        *"100%"*) $BRIGHTNESSCTL set 100% -q ;;
        *"80%"*)  $BRIGHTNESSCTL set 80%  -q ;;
        *"60%"*)  $BRIGHTNESSCTL set 60%  -q ;;
        *"40%"*)  $BRIGHTNESSCTL set 40%  -q ;;
        *"20%"*)  $BRIGHTNESSCTL set 20%  -q ;;
        *"10%"*)  $BRIGHTNESSCTL set 10%  -q ;;
    esac
else
    python3 $SLIDER brightness "󰃠  Brightness" "$PCT"
fi
