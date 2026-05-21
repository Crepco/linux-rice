#!/bin/bash
WPCTL=/usr/bin/wpctl
ROFI=/usr/bin/rofi
SLIDER=/home/crepco/.config/waybar/scripts/slider.py

VOL=$($WPCTL get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d", $2*100}')
MUTED=$($WPCTL get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED)

if [ "$1" = "menu" ]; then
    [ "$MUTED" -gt 0 ] && STATUS="󰝟  Volume — MUTED ($VOL%)" || STATUS="󰕾  Volume — $VOL%"
    [ "$MUTED" -gt 0 ] && MUTE_OPT="󰕾  Unmute" || MUTE_OPT="󰝟  Mute"

    CHOICE=$(printf "$MUTE_OPT\n󰝞  100%%\n󰖀   80%%\n󰖀   60%%\n󰖀   40%%\n󰕿   20%%\n󰕿   10%%" | $ROFI -dmenu \
        -mesg "$STATUS" \
        -theme /home/crepco/.config/rofi/dropdown.rasi \
        -no-custom -p "")
    [ -z "$CHOICE" ] && exit 0
    case "$CHOICE" in
        *"Mute"*)   $WPCTL set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
        *"Unmute"*) $WPCTL set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
        *"100%"*)   $WPCTL set-volume @DEFAULT_AUDIO_SINK@ 1.0 ;;
        *"80%"*)    $WPCTL set-volume @DEFAULT_AUDIO_SINK@ 0.8 ;;
        *"60%"*)    $WPCTL set-volume @DEFAULT_AUDIO_SINK@ 0.6 ;;
        *"40%"*)    $WPCTL set-volume @DEFAULT_AUDIO_SINK@ 0.4 ;;
        *"20%"*)    $WPCTL set-volume @DEFAULT_AUDIO_SINK@ 0.2 ;;
        *"10%"*)    $WPCTL set-volume @DEFAULT_AUDIO_SINK@ 0.1 ;;
    esac
else
    python3 $SLIDER volume "󰕾  Volume" "$VOL"
fi
