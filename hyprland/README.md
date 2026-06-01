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
- `swww` (via `awww`) — sets `~/Pictures/wallpapers/wallpaper.png` with a fade transition

## Keybinds

`$mainMod = SUPER` (the Windows key).

### Apps & window control

| Bind | Action |
| --- | --- |
| `SUPER + T` | Launch terminal (kitty) |
| `SUPER + B` | Launch browser (brave) |
| `SUPER + E` | Launch file manager (dolphin) |
| `SUPER + R` | App launcher (Quickshell — `qs ipc call launcher toggle`) |
| `SUPER + L` | Lock screen (Quickshell — `qs ipc call lock activate`) |
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

- `XF86AudioRaiseVolume` / `LowerVolume` / `Mute` → `wpctl` (+ Quickshell volume OSD)
- `XF86MonBrightnessUp` / `Down` → `brightnessctl -e4 -n2 set 5%±` (+ Quickshell brightness OSD)
- `XF86AudioPlay` / `Pause` / `Next` / `Prev` → `playerctl`

## Look & feel

- **Gaps:** in 1px, out 2px
- **Borders:** 2px, gradient `#e2aaa1 → #e9cdb0 @ 45°` (peach → cream) active, dim `#4d4f63` inactive
- **Rounding:** 10px (power 2)
- **Blur:** size 3, 1 pass
- **Opacity:** active 1.0, inactive 0.95
- **Screen shader:** [shaders/vibrance.glsl](shaders/vibrance.glsl) (boosts saturation)
- **Layout:** dwindle with `preserve_split` and pseudotile

## Window rules

| Rule | Target |
| --- | --- |
| Opacity `0.60 / 0.50` (so the blurred wallpaper bleeds through) | `class:Spotify` |

## lockscreen — Quickshell

Implemented in QML at [../quickshell/lock/LockScreen.qml](../quickshell/lock/LockScreen.qml), triggered via `qs ipc call lock activate`. PAM auth references the `hyprlock` PAM config (`/etc/pam.d/hyprlock`) — keep the `hyprlock` package installed for that file, or swap the `config:` line in `LockScreen.qml` to `system-auth` if uninstalling.

## hyprpaper

[hyprpaper.conf](hyprpaper.conf) is kept for reference, but the active [hyprland.conf](hyprland.conf) starts **swww** (via `awww`) instead — that's the wallpaper mechanism actually in use.

## Notes

- Display output is `eDP-1` (internal laptop screen) — update [hyprland.conf](hyprland.conf) and [hyprpaper.conf](hyprpaper.conf) for external monitors.
- All wallpaper/user paths are hard-coded for `/home/crepco/`.
