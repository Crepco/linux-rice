# kitty

[kitty](https://sw.kovidgoyal.net/kitty/) terminal config — paired with the **Yoake (夜明け)** color scheme.

## Files

| File | Purpose |
| --- | --- |
| [kitty.conf](kitty.conf) | Main config — includes the theme, sets font, cursor, opacity |
| [yoake.conf](yoake.conf) | Standalone Yoake color scheme (sourced from `kitty.conf`) |

## Settings of note

From [kitty.conf](kitty.conf):

- **Font:** JetBrainsMono Nerd Font, 11pt, 110% cell height
- **Cursor:** beam with a fading trail; mouse pointer hides after 2s
- **Background opacity:** 0.65 (transparent — relies on Hyprland blur)
- **Scrollback:** 10 000 lines
- **`confirm_os_window_close`:** disabled

## Color scheme — Yoake (夜明け)

A warm twilight palette — peach/cream cloud tones on a deep night-slate base. Defined in [yoake.conf](yoake.conf), MIT-licensed. Highlights:

| Role | Hex |
| --- | --- |
| Background | `#20202f` deep night slate |
| Foreground | `#e9cdb0` warm cream |
| Cursor / selection / active border / red (color1) | `#e2aaa1` peach |
| Yellow (color3) / bell border | `#e9cdb0` cream gold |
| Blue (color4) | `#7a8ca8` cool slate |
| Magenta (color5) | `#9e8c9c` lavender mauve |
| Green (color2) | `#90a89c` muted sage |
| Cyan (color6) | `#8aa0a0` dusty teal |

Tab bar uses peach `#e2aaa1` (active) / surface `#363849` (inactive).
