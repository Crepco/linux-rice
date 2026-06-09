# hyprland

[Hyprland](https://hypr.land) compositor config. Yoake-themed window borders (peach → cream gradient active border @ 45°), gentle blur, rounded corners, and a slide animation for workspace switching.

Place these files in `~/.config/hypr/` (the tool reads from `hypr/`, not `hyprland/`).

## Files

| File | Purpose |
| --- | --- |
| [hyprland.conf](hyprland.conf) | Main config — monitors, autostart, look & feel, input, keybinds, window rules |
| [hyprpaper.conf](hyprpaper.conf) | hyprpaper wallpaper config (note: the active config starts `swww` instead — see below) |
| [shaders/](shaders/) | Screen shaders (vibrance boost) — see [shaders/README.md](shaders/README.md) |

> Lockscreen, bar, launcher, notifications, and OSD are all provided by Quickshell — see [../quickshell/](../quickshell/).

## Autostart

From [hyprland.conf](hyprland.conf):

- `quickshell` — the desktop shell (bar, launcher, notifications, OSD, lockscreen)
- `awww` (the swww successor) — sets `~/Pictures/wallpapers/wallpaper.png` with a fade transition
- `hyprpolkitagent` — polkit auth agent so GUI apps can show password prompts

## Keybinds

`$mainMod = SUPER` (the Windows key).

### Apps & window control

| Bind | Action |
| --- | --- |
| `SUPER + T` | Launch terminal (kitty) |
| `SUPER + B` | Launch browser (brave) |
| `SUPER + E` | Launch file manager (nautilus) — `SHIFT` for yazi |
| `SUPER + R` | App launcher (Quickshell — `qs ipc call launcher toggle`) |
| `SUPER + L` | Lock screen (Quickshell — `qs ipc call lock activate`) |
| `SUPER + W` | Kill active window |
| `SUPER + X` | Toggle floating |
| `SUPER + F` | Fullscreen — `SHIFT` for maximize (bar stays visible) |
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
| `SUPER + CTRL + arrow keys` | Move window within the layout |
| `SUPER + LMB drag` | Move window |
| `SUPER + RMB drag` | Resize window |
| 3-finger horizontal swipe | Switch workspace |

### Media / hardware keys

- `XF86AudioRaiseVolume` / `LowerVolume` / `Mute` → `wpctl` (+ Quickshell volume OSD)
- `XF86MonBrightnessUp` / `Down` → `brightnessctl -e4 -n2 set 5%±` (+ Quickshell brightness OSD)
- `XF86AudioPlay` / `Pause` / `Next` / `Prev` → `playerctl`

## Look & feel

- **Gaps:** in 1px, out 2px
- **Borders:** 2px, gradient `#e2aaa1 → #e9cdb0 @ 45°` (peach → cream) active, dim `#4d4f63` inactive
- **Rounding:** 10px (power 2)
- **Blur:** size 6, 3 passes
- **Opacity:** active 1.0, inactive 0.95
- **Screen shader:** [shaders/vibrance.glsl](shaders/vibrance.glsl) (boosts saturation to 1.6)
- **Layout:** dwindle with `preserve_split` and pseudotile

## Window & layer rules

| Rule | Target |
| --- | --- |
| Suppress maximize requests | all windows |
| Float | xdg portal file pickers |
| Opacity `0.60 / 0.50` (so the blurred wallpaper bleeds through) | `class:Spotify` |
| Blur (frosted glass behind the translucent bar island / popups) | Quickshell layers |

## lockscreen — Quickshell

Implemented in QML at [../quickshell/lock/LockScreen.qml](../quickshell/lock/LockScreen.qml), triggered via `qs ipc call lock activate`. PAM auth uses the standard `system-auth` config (`/etc/pam.d/system-auth`) — no extra packages needed.

## hyprpaper

[hyprpaper.conf](hyprpaper.conf) is kept for reference, but the active [hyprland.conf](hyprland.conf) starts **swww** (via `awww`) instead — that's the wallpaper mechanism actually in use.

## Notes

- Display output is `eDP-1` (internal laptop screen) — update [hyprland.conf](hyprland.conf) and [hyprpaper.conf](hyprpaper.conf) for external monitors.
- All wallpaper/user paths are hard-coded for `/home/crepco/`.
