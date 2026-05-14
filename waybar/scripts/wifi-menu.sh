#!/bin/bash
WIFI_STATE=$(nmcli radio wifi)
CURRENT=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2)

if [ "$WIFI_STATE" = "disabled" ]; then
    STATUS="󰤭  WiFi — OFF"
    CHOICE=$(printf "󰤨  Enable WiFi" | rofi -dmenu \
        -mesg "$STATUS" \
        -theme /home/crepco/.config/rofi/dropdown.rasi \
        -no-custom -p "")
    [ -n "$CHOICE" ] && nmcli radio wifi on
    exit 0
fi

[ -n "$CURRENT" ] && STATUS="󰤨  Connected — $CURRENT" || STATUS="󰤭  WiFi — not connected"

NETWORKS=$(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list 2>/dev/null \
    | grep -v '^:' \
    | awk -F: '!seen[$1]++ && $1!="" {
        s=$2+0; ssid=$1
        if (s>75) ic="󰤨"
        else if (s>50) ic="󰤥"
        else if (s>25) ic="󰤢"
        else ic="󰤟"
        lock=($3!="--"&&$3!="")?" 󰌾":""
        printf "%s  %s%s\n", ic, ssid, lock
    }' | head -10)

ITEMS="󰤭  Turn WiFi Off\n󰑐  Rescan\n$NETWORKS"

CHOICE=$(printf "$ITEMS" | rofi -dmenu \
    -mesg "$STATUS" \
    -theme /home/crepco/.config/rofi/dropdown.rasi \
    -no-custom -p "")

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    *"Turn WiFi Off"*) nmcli radio wifi off ;;
    *"Rescan"*)
        nmcli dev wifi rescan 2>/dev/null
        sleep 2 && exec "$0" ;;
    *)
        SSID=$(echo "$CHOICE" | sed 's/^.  //' | sed 's/ 󰌾//' | xargs)
        if [ "$SSID" = "$CURRENT" ]; then
            nmcli dev disconnect "$(nmcli -t -f DEVICE,TYPE dev | grep wifi | cut -d: -f1 | head -1)"
        else
            nmcli dev wifi connect "$SSID" 2>/dev/null || nm-connection-editor &
        fi ;;
esac
