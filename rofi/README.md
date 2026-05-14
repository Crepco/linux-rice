# rofi

[Rofi](https://github.com/davatorium/rofi) — used both as the main app launcher (Super+R) and as the dropdown menu engine for the waybar quick-actions (wifi, bluetooth, volume, brightness).

## Files

| File | Purpose |
| --- | --- |
| [config.rasi](config.rasi) | Main launcher theme — large centered window with wallpaper sidebar, mode switcher, app grid |
| [colors.rasi](colors.rasi) | Shared cyberpunk/synthwave color tokens — imported by both themes |
| [dropdown.rasi](dropdown.rasi) | Compact top-right dropdown — used by waybar scripts for menus |

## Modes (main launcher)

From [config.rasi](config.rasi) → `configuration.modi`:

- `drun` — Applications (default)
- `run` — raw run
- `window` — window switcher

Bound to `SUPER + R` in [../hyprland/hyprland.conf](../hyprland/hyprland.conf).

## Main launcher layout

- 1000px wide centered window, 2px outlined, 15px corner radius
- Left **imagebox** shows `/home/crepco/Pictures/wallpapers/wallpaper.png` with the search bar and mode switcher overlaid
- Right **listbox** shows up to 8 results in a single column, 32px icons (Colloid icon theme)
- Font: Hack Nerd Font 10

## Dropdown ([dropdown.rasi](dropdown.rasi))

Used by the waybar scripts to render quick action menus:

- Anchored to **top-right** (`x:-10, y:50` offset)
- 260px wide, 12px rounded, near-opaque `#0d0d15`
- Hover-select enabled — clicking an entry confirms immediately
- Header shows context via `-mesg "$STATUS"` from the calling script

## Colors ([colors.rasi](colors.rasi))

Cyberpunk/Synthwave Material-style tokens. Both themes reference these via `@token` so swapping the palette only needs editing this one file. Highlights:

| Token | Hex |
| --- | --- |
| `primary` | `#ff4081` (hot pink) |
| `secondary` | `#64c8ff` (cyan) |
| `tertiary` | `#b967ff` (purple) |
| `surface` / `background` | `#0d0d15` |
| `on-surface` | `#e8e6f0` |
| `error` | `#ff2e63` |
