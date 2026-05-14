# waybar

Top status bar — [Waybar](https://github.com/Alexays/Waybar) styled to match the cyberpunk theme. Three pill groups: left (workspaces + system), center (clock), right (connectivity + audio + battery).

## Files

| File | Purpose |
| --- | --- |
| [config.jsonc](config.jsonc) | Module layout, behavior, and click handlers |
| [style.css](style.css) | Cyberpunk pill styling |
| [scripts/](scripts/) | Interactive menus and the tkinter slider — see [scripts/README.md](scripts/README.md) |

## Layout

```
┌────────────────────────────────────────────────────────────────────┐
│  workspaces  uptime  cpu          clock           bt net vol bl bat │
└────────────────────────────────────────────────────────────────────┘
```

- **layer:** top, **position:** top, margin-bottom -7
- **Font:** Symbols Nerd Font / Hack Nerd Font / Inter, 13px

## Modules

### Left

| Module | Notes |
| --- | --- |
| `hyprland/workspaces` | Shows `name: icon` per workspace; active uses `󰐏`, idle uses `󰐘` |
| `custom/uptime` | Runs [scripts/uptime.sh](scripts/uptime.sh) every 60s — renders `⏱ 1d 4h 23m` style |
| `cpu` | 1s interval; mini bar graph + percent; **click → open `kitty -e btop`** |

### Center

| Module | Notes |
| --- | --- |
| `clock` | `HH:MM:SS  -  Weekday, DD`, **Asia/Kolkata timezone**, 1s tick |

### Right

| Module | Notes |
| --- | --- |
| `bluetooth` | Icon switches by state. **Click → [scripts/bluetooth-menu.sh](scripts/bluetooth-menu.sh)** (rofi dropdown) |
| `network` | Wifi / ethernet / disconnected icons. **Click → [scripts/wifi-menu.sh](scripts/wifi-menu.sh)** |
| `pulseaudio` | Volume icon + percent. **Left-click → slider**, **right-click → preset menu** ([scripts/volume-menu.sh](scripts/volume-menu.sh)) |
| `backlight` | Brightness icon + percent. **Left-click → slider**, **right-click → preset menu** ([scripts/brightness-menu.sh](scripts/brightness-menu.sh)) |
| `battery` | Capacity + state icon. Warning at 30%, critical at 15%. Special icons for charging/plugged |

## Styling

[style.css](style.css) builds three pill groups:

- **Left** — three separate pills (`#workspaces`, `#custom-uptime`, `#cpu`), each on `#16162a` with a faint pink hairline border, hover → `#1c1c32` with a brighter pink edge.
- **Center** — single `#clock` pill on `#16162a` with a cyan border + subtle cyan glow, intensified on hover.
- **Right** — five modules fused into one connected pill (rounded only on the outer caps `#bluetooth` and `#battery`), bordered top and bottom with translucent cyan.

Per-module accent colors:

| State | Color |
| --- | --- |
| bluetooth on | cyan `#64c8ff` |
| bluetooth connected | pink `#ff4081` |
| network disconnected | red `#ff2e63` |
| pulseaudio muted | dim white |
| backlight | purple `#c896ff` |
| battery charging / plugged | green `#64ffda` |
| battery warning | pink |
| battery critical | red |

Tooltips share the dark cyberpunk surface with a pink border and soft pink shadow.

## Dependencies

| Package | Used by |
| --- | --- |
| `wireplumber` (`wpctl`) | volume |
| `brightnessctl` | brightness |
| `bluez-utils` (`bluetoothctl`), `blueman` | bluetooth menu |
| `networkmanager` (`nmcli`), `nm-connection-editor` | wifi menu |
| `python3` + `tkinter` | slider GUI |
| `rofi` | all dropdown menus |
| `btop` | cpu click handler |
