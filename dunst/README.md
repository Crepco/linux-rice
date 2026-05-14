# dunst

[dunst](https://dunst-project.org/) notification daemon — styled to match the cyberpunk theme. Launched on Hyprland startup via the `exec-once = dunst` line in [../hyprland/hyprland.conf](../hyprland/hyprland.conf).

## Files

| File | Purpose |
| --- | --- |
| [dunstrc](dunstrc) | All settings — global, urgency levels, mouse bindings |

## Window

- **Position:** top-right with 12×12 offset
- **Size:** 320×120, up to 5 notifications stacked, 6px gap between them
- **Look:** dark `#16162a` surface, 2px pink `#ff4081` frame, 10px corner radius, 10% transparency
- **Progress bar:** 3px tall, 280px wide, 2px corner radius
- **Font:** Hack Nerd Font 10, full pango markup
- **Format:** `<b>title</b>\nbody`
- **Icons:** Adwaita theme, left-aligned, 32–48px, 4px rounded

## Urgency styles

| Urgency | Background | Foreground | Frame | Timeout |
| --- | --- | --- | --- | --- |
| low | `#16162a` | `#c6d0f5` | `#333348` | 4s |
| normal | `#16162a` | `#c6d0f5` | `#ff4081` (pink) | 6s |
| critical | `#16162a` | `#ff4081` (pink) | `#64c8ff` (cyan) | ∞ |

## Mouse bindings

| Button | Action |
| --- | --- |
| Left | Close current notification |
| Middle | Do action (and close current) |
| Right | Close all notifications |

## Other

- **History:** keeps the last 20 notifications (`dunstctl history-pop` to recall)
- **Idle threshold:** 120s
- **Stack duplicates:** yes
- **Browser** (for clicking URLs in notifications): `/usr/bin/brave`
