# fastfetch

[fastfetch](https://github.com/fastfetch-cli/fastfetch) terminal system info. An inline image logo on the left (rendered via the kitty graphics protocol) beside a simple key/value module list with **peach keys**, topped and tailed by a Nerd Font color bar.

## Files

| File | Purpose |
| --- | --- |
| [config.jsonc](config.jsonc) | Logo, modules, layout, colors |
| `logo.png` | The logo image (referenced by `config.jsonc`) |

## Install

```bash
sudo pacman -S fastfetch
```

## Logo image

The config renders `~/.config/fastfetch/logo.png` via the kitty graphics protocol (`"type": "kitty"`, height 13). Replace `logo.png` with any PNG to change it.

The kitty graphics protocol only works in kitty — running fastfetch elsewhere (TTY, other terminals) won't show the image. Switch `"type"` in the `logo` block to `"sixel"` or `"chafa"` for cross-terminal support.

## Colors

Keys use ANSI color `31` (terminal `color1`), which resolves to **peach `#e2aaa1`** through the kitty [Yoake theme](../kitty/yoake.conf). The decorative bars at the top and bottom step through ANSI `31`–`36`. Because the colors are ANSI-indexed, fastfetch automatically matches whatever terminal palette is active.

## Modules

In order, from [config.jsonc](config.jsonc):

| Key | Module |
| --- | --- |
| (color bar) | `custom` — ANSI swatch row |
|  title | `title` — user@host |
|  os | `os` |
|  kernel | `kernel` |
| 󰏗 packages | `packages` (pacman) |
|  shell | `shell` |
|  terminal | `terminal` |
|  wm | `wm` |
|  cursor | `cursor` |
|  terminalfont | `terminalfont` |
| 󰔟 uptime | `uptime` |
|  datetime | `datetime` |
| (color bar) | `custom` — ANSI swatch row |

## Run

```bash
fastfetch
```

To run on every terminal launch, add `fastfetch` to `~/.bashrc`.
