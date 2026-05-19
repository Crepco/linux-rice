# fastfetch

[fastfetch](https://github.com/fastfetch-cli/fastfetch) terminal system info. Boxed layout with **pink borders**, **cyan icons**, **white key labels**, dim italic values — plus an inline image logo on the left rendered via the kitty graphics protocol.

## Files

| File | Purpose |
| --- | --- |
| [config.jsonc](config.jsonc) | Logo, modules, layout, colors |

## Install

```bash
sudo pacman -S fastfetch
```

## Logo image

The config expects an image at `~/Pictures/fetch-logo.png`. Drop **any** PNG/JPG there:

```bash
mkdir -p ~/Pictures
cp /path/to/some-image.png ~/Pictures/fetch-logo.png
```

If the file is missing, fastfetch falls back to the built-in Arch ASCII logo.

The kitty graphics protocol only works in kitty — running fastfetch elsewhere (TTY, other terminals) shows the ASCII fallback. Switch `"type"` in the `logo` block to `"sixel"` or `"chafa"` for cross-terminal support.

## Layout

```
╭───────────╮
│  user    │ crepco
│ 󰅐 uptime  │ 1 day, 4 hours, 23 mins
│ 󰣇 distro  │ Arch Linux
│  kernel  │ 6.18.4-arch1-1
│  wm      │ Hyprland
│ 󰇄 desktop │ (skipped if no DE)
│  term    │ kitty
│  shell   │ bash
│ 󰏖 apps    │ 759 (pacman)   1 (flatpak)
│ 󰉉 disk    │ 20.9 GiB / 46.0 GiB (45%)
│  memory  │ 5.5 GiB / 14.8 GiB (37%)
│ 󱦟 os age  │ 237 days
├───────────┤
│  colors  │ ● ● ● ● ● ● ● ●
╰───────────╯
```

## Colors

Format strings use truecolor SGR sequences for portability:

| Element | Color | Code |
| --- | --- | --- |
| Box borders | hot pink | `{#38;2;255;64;129}` (`#ff4081`) |
| Module icons | electric cyan | `{#38;2;100;200;255}` (`#64c8ff`) |
| Key labels | white | `{#white}` |
| Values | dim italic white | `{#2}{#3}` |
| Reset | — | `{#0}` |

To change the accent color globally, find-replace `38;2;255;64;129` (pink) or `38;2;100;200;255` (cyan) in [config.jsonc](config.jsonc).

## Modules

| Key | Module | Source |
| --- | --- | --- |
|  user | `title` | Just the username |
| 󰅐 uptime | `uptime` | days / hours / mins |
| 󰣇 distro | `os` | distro pretty name |
|  kernel | `kernel` | kernel release |
|  wm | `wm` | window manager |
| 󰇄 desktop | `de` | desktop environment (skipped if none) |
|  term | `terminal` | terminal name |
|  shell | `shell` | shell name |
| 󰏖 apps | `command` | pacman package count + flatpak count (if installed) |
| 󰉉 disk | `disk` | `/` mount only |
|  memory | `memory` | used / total |
| 󱦟 os age | `command` | days since OS install (uses `stat -c %W /`) |
|  colors | `colors` | 16-circle color preview |

## Run

```bash
fastfetch
```

To run on every terminal launch, add to `~/.bashrc`:

```bash
fastfetch
```
