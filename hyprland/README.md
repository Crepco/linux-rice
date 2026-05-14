# hyprland

[Hyprland](https://hypr.land) compositor config. Cyberpunk-themed window borders, gradient active border (pink → cyan @ 45°), gentle blur, rounded corners, and a slide animation for workspace switching.

Place these files in `~/.config/hypr/` (the tool reads from `hypr/`, not `hyprland/`).

## Files

| File | Purpose |
| --- | --- |
| [hyprland.conf](hyprland.conf) | Main config — monitors, autostart, look & feel, input, keybinds, window rules |
| [hyprlock.conf](hyprlock.conf) | Lockscreen layout — clock split into pink hour / cyan minute, date, user, input field |
| [hyprpaper.conf](hyprpaper.conf) | Wallpaper for the `eDP-1` output |
| [shaders/](shaders/) | Screen shaders (vibrance boost) — see [shaders/README.md](shaders/README.md) |

## Autostart

From [hyprland.conf](hyprland.conf):

- `waybar` — top bar
- `dunst` — notifications
- `swww-daemon` + sets `~/Pictures/wallpapers/wallpaper.png` via fade transition

## Keybinds

`$mainMod = SUPER` (the Windows key).

### Apps & window control

| Bind | Action |
| --- | --- |
| `SUPER + T` | Launch terminal (kitty) |
| `SUPER + B` | Launch browser (brave) |
| `SUPER + E` | Launch file manager (dolphin) |
| `SUPER + R` | App launcher (rofi -show drun) |
| `SUPER + L` | Lock screen (hyprlock) |
| `SUPER + W` | Kill active window |
| `SUPER + X` | Toggle floating |
| `SUPER + P` | Pseudo tile (dwindle) |
| `SUPER + J` | Toggle split direction (dwindle) |
| `SUPER + M` | **Exit Hyprland** |

### Screenshots

| Bind | Action |
| --- | --- |
| `SUPER + SHIFT + S` | Region screenshot (grim + slurp) → `~/Pictures/Screenshots/` + clipboard |
| `Print` | Fullscreen screenshot → `~/Pictures/Screenshots/` + clipboard |

### Workspaces

| Bind | Action |
| --- | --- |
| `SUPER + 1..0` | Switch to workspace 1..10 |
| `SUPER + SHIFT + 1..0` | Move window to workspace 1..10 |
| `SUPER + S` | Toggle scratchpad (special workspace `magic`) |
| `SUPER + scroll` | Cycle workspaces |
| `SUPER + arrow keys` | Move focus |
| `SUPER + LMB drag` | Move window |
| `SUPER + RMB drag` | Resize window |
| 3-finger horizontal swipe | Switch workspace |

### Media / hardware keys

- `XF86AudioRaiseVolume` / `LowerVolume` / `Mute` → `wpctl`
- `XF86MonBrightnessUp` / `Down` → `brightnessctl -e4 -n2 set 5%±`
- `XF86AudioPlay` / `Pause` / `Next` / `Prev` → `playerctl`

## Look & feel

- **Gaps:** in 1px, out 2px
- **Borders:** 2px, gradient `#ff4081 → #64c8ff @ 45°` active, dim `#333348` inactive
- **Rounding:** 10px (power 2)
- **Blur:** size 3, 1 pass, vibrancy 0.1696
- **Opacity:** active 1.0, inactive 0.95
- **Screen shader:** [shaders/vibrance.glsl](shaders/vibrance.glsl) (boosts saturation)
- **Layout:** dwindle with `preserve_split` and pseudotile

## Window rules

| Rule | Target |
| --- | --- |
| Slide-in animation | `class:^(rofi)$` |
| Float, 360×80, fixed position, popin | Windows titled `Volume` or `Brightness` (the tkinter slider from [../waybar/scripts/slider.py](../waybar/scripts/slider.py)) |

## hyprlock — lockscreen

- Wallpaper blurred (3 passes, size 8), slightly dimmed, with subtle noise
- Hour displayed in **pink** `#ff4081`, minute in **cyan** `#64c8ff`, both 125pt GohuFont
- Date below in white
- `⚡ $USER` label, then password input with placeholder `⚡ ACCESS DENIED ⚡`

## hyprpaper

Hard-codes `/home/crepco/Downloads/wallpaper2_rgb.png` for the `eDP-1` output. Note: [hyprland.conf](hyprland.conf) also starts `swww` with a different wallpaper — only one will visibly apply depending on which loads last.

## Notes

- Display output is `eDP-1` (internal laptop screen) — update [hyprland.conf](hyprland.conf) and [hyprpaper.conf](hyprpaper.conf) for external monitors.
- All wallpaper/user paths are hard-coded for `/home/crepco/`.
