# waybar/scripts

Helper scripts invoked by waybar modules. Most render a rofi dropdown styled by [../../rofi/dropdown.rasi](../../rofi/dropdown.rasi); two of them (volume, brightness) fall back to a tkinter slider window from [slider.py](slider.py).

## Files

| Script | Trigger | What it does |
| --- | --- | --- |
| [uptime.sh](uptime.sh) | waybar `custom/uptime` (every 60s) | Outputs a compact uptime string (`1d 4h 23m`) by post-processing `uptime -p` |
| [wifi-menu.sh](wifi-menu.sh) | click on waybar `network` | Wifi state, scan, connect/disconnect via `nmcli` |
| [bluetooth-menu.sh](bluetooth-menu.sh) | click on waybar `bluetooth` | Bluetooth toggle, manager, connect/disconnect paired devices |
| [volume-menu.sh](volume-menu.sh) | left/right click on waybar `pulseaudio` | Left-click: slider. Right-click (`menu` arg): rofi preset (10/20/40/60/80/100% + mute) |
| [brightness-menu.sh](brightness-menu.sh) | left/right click on waybar `backlight` | Left-click: slider. Right-click (`menu` arg): rofi preset (10/20/40/60/80/100%) |
| [slider.py](slider.py) | invoked by volume / brightness scripts | tkinter floating slider, themed cyberpunk |

## slider.py

Small tkinter window that drags volume or brightness live.

```
python3 slider.py <volume|brightness> "<title>" <current_pct>
```

- 360×80 floating window, topmost
- Pink slider on a dark track, current percent shown in cyan
- Updates `wpctl set-volume` (volume mode) or `brightnessctl set` (brightness mode) on every value change
- Closes on `Escape` or `Return`

Hyprland window rules in [../../hyprland/hyprland.conf](../../hyprland/hyprland.conf) match titles `Volume`/`Brightness` and apply float + fixed position + popin animation.

## wifi-menu.sh

- Shows current SSID in the header
- Lists "Turn WiFi Off", "Rescan", then up to 10 visible networks with signal-strength icons (`󰤨/󰤥/󰤢/󰤟`) and a lock icon for secured networks
- Selecting a network runs `nmcli dev wifi connect <ssid>`; if that fails it opens `nm-connection-editor`
- Selecting the current network disconnects

## bluetooth-menu.sh

- If powered off: offers a single "Enable Bluetooth" entry
- If powered on: toggle off, open `blueman-manager`, then a list of paired devices with `[connected]` tags
- Selecting a non-connected device runs `bluetoothctl connect`; selecting a connected one disconnects

## volume-menu.sh / brightness-menu.sh

Each accepts a single optional `menu` argument:

- **No arg** → spawns [slider.py](slider.py) for live drag
- **`menu`** → spawns a rofi dropdown with mute/unmute (volume only) + percentage presets

Both read current state via `wpctl get-volume` / `brightnessctl get` and pass it into the slider/menu header.

## uptime.sh

```bash
uptime -p | sed -e 's/up //' -e 's/ days\?/d/g' -e 's/ hours\?/h/g' -e 's/ minutes\?/m/g' -e 's/, / /g'
```

Strips the `up ` prefix and shortens unit names so the output fits the bar.

## Hardcoded paths

All scripts reference `/home/crepco/.config/...` and `/home/crepco/.config/rofi/dropdown.rasi` directly. Update these if your home directory differs.
