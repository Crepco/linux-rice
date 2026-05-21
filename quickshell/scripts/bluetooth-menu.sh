#!/bin/bash
POWERED=$(bluetoothctl show | grep -c "Powered: yes")

if [ "$POWERED" -eq 0 ]; then
    STATUS="󰂲  Bluetooth — OFF"
    ITEMS="󰂯  Enable Bluetooth"
else
    STATUS="󰂯  Bluetooth — ON"
    TOGGLE="󰂲  Disable Bluetooth"
    MANAGER="󰒄  Bluetooth Manager"

    DEVICES=""
    while IFS= read -r line; do
        MAC=$(echo "$line" | awk '{print $2}')
        NAME=$(echo "$line" | cut -d' ' -f3-)
        if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
            DEVICES="${DEVICES}󰂱  ${NAME}  [connected]\n"
        else
            DEVICES="${DEVICES}󰂰  ${NAME}\n"
        fi
    done < <(bluetoothctl devices)

    ITEMS="$TOGGLE\n$MANAGER"
    [ -n "$DEVICES" ] && ITEMS="$ITEMS\n$DEVICES"
fi

CHOICE=$(printf "$ITEMS" | rofi -dmenu \
    -mesg "$STATUS" \
    -theme /home/crepco/.config/rofi/dropdown.rasi \
    -no-custom -p "")

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    *"Enable"*)   bluetoothctl power on ;;
    *"Disable"*)  bluetoothctl power off ;;
    *"Manager"*)  blueman-manager & ;;
    *"[connected]"*)
        NAME=$(echo "$CHOICE" | sed 's/^..  //' | sed 's/  \[connected\]//')
        MAC=$(bluetoothctl devices | grep "$NAME" | awk '{print $2}')
        bluetoothctl disconnect "$MAC" ;;
    *)
        NAME=$(echo "$CHOICE" | sed 's/^..  //')
        MAC=$(bluetoothctl devices | grep "$NAME" | awk '{print $2}')
        [ -n "$MAC" ] && bluetoothctl connect "$MAC" ;;
esac
