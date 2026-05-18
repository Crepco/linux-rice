# neofetch

[neofetch](https://github.com/dylanaraps/neofetch) terminal system info — themed to match the cyberpunk rice (hot pink keys, electric cyan values, purple accents).

> **Heads-up:** neofetch was archived in April 2024 and dropped from the Arch official repos. It's still available via the AUR. Maintained alternatives: [hyfetch](https://github.com/hykilpikonna/hyfetch) (v2.x is a frontend that wraps neofetch/fastfetch/macchina), [fastfetch](https://github.com/fastfetch-cli/fastfetch) (fast C rewrite).

## Files

| File | Purpose |
| --- | --- |
| [config.conf](config.conf) | Layout, colors, modules, ASCII settings |

## Install

neofetch was dropped from the Arch official repos. Install from the AUR:

```bash
yay -S neofetch
```

## Run

```bash
neofetch
```

Reads `~/.config/neofetch/config.conf` automatically.

To run on every terminal launch, add to `~/.bashrc`:

```bash
neofetch
```

## Modules shown

In order from [config.conf](config.conf):

1. **title** — `user@host` (pink user, cyan `@`, pink host)
2. **underline** — purple dash row
3. **os** — full distro + arch (`os_arch="on"`)
4. **kernel** — short version (`kernel_shorthand="on"`)
5. **host** — machine model
6. **uptime** — tiny format (`1d 4h`)
7. **pkgs** — package count + per-manager breakdown
8. **shell** — shell name + version, no full path
9. **wm** — window manager (Hyprland)
10. **term** — terminal name (kitty)
11. **cpu** — brand + speed + logical cores, no temp
12. **gpu** — all GPUs, brand included
13. **memory** — `used / total (percent%)` in GiB
14. **cols** — 16-block color row at the bottom

Disk is configured but not added to `print_info()` — uncomment the `info "disk"` call to enable.

## Colors

[config.conf](config.conf) uses 256-color ANSI codes for the cyberpunk palette:

| Slot | Code | Used for |
| --- | --- | --- |
| 198 | hot pink (`#ff4081`-ish) | title, user, host, keys |
| 51 | electric cyan (`#64c8ff`-ish) | `@`, info values |
| 141 | purple (`#c896ff`-ish) | underline, colons |

The Arch ASCII logo uses the same palette via `ascii_colors=(198 51 198 51 141 198)`.

## Customizing

- Want full color block range: edit `block_range=(0 15)` → `block_range=(0 255)` (slow on some terminals)
- Add disk usage: add `info "disk  " disk` inside `print_info()`
- Different logo: set `ascii_distro="arch_small"` for the compact variant, or `ascii_distro="off"` to drop the logo entirely
- Custom logo: set `image_backend="ascii"` + `ascii_distro="/path/to/logo.txt"`

## Differences from the old fastfetch config

| | fastfetch | neofetch |
| --- | --- | --- |
| Format | JSON (`config.jsonc`) | Bash (`config.conf`) |
| Logo | Custom `arch.txt` | Built-in Arch ASCII via `ascii_distro="arch"` |
| Speed | Fast (compiled C) | Slower (pure bash) |
| Source | Official Arch repo | AUR (upstream archived 2024) |
