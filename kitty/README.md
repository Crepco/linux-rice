# kitty

[kitty](https://sw.kovidgoyal.net/kitty/) terminal config — paired with a custom **Cyberpunk-Synthwave** color scheme.

## Files

| File | Purpose |
| --- | --- |
| [kitty.conf](kitty.conf) | Main config — includes the theme, sets font, cursor, opacity |
| [cyberpunk.conf](cyberpunk.conf) | Standalone Cyberpunk-Synthwave color scheme (sourced from `kitty.conf`) |

## Settings of note

From [kitty.conf](kitty.conf):

- **Font:** Hack Nerd Font, 12pt
- **Cursor:** block, hides after 2s of inactivity
- **Line height:** 120%
- **URLs:** dotted underline in `#64c8ff` (cyan)
- **Background opacity:** 0.75 (transparent — relies on Hyprland blur)
- **`confirm_os_window_close`:** disabled

## Color scheme — Cyberpunk-Synthwave

Defined in [cyberpunk.conf](cyberpunk.conf). MIT-licensed. Highlights:

| Role | Hex |
| --- | --- |
| Background | `#16162a` |
| Foreground | `#ffffff` |
| Cursor / selection / active border / red (color1) | `#ff4081` neon pink |
| URL / blue (color4) / bell border | `#64c8ff` electric blue |
| Magenta (color5) | `#e91e63` |
| Bright purple (color13) | `#f06292` |
| Green (color2) | `#64ffda` cyan-green |
| Cyan (color6) | `#00e5ff` |
| Yellow (color3) | `#ffeb3b` |

Tab bar uses the pink (active) / muted purple `#c896ff` (inactive) split.
