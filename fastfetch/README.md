# fastfetch

[fastfetch](https://github.com/fastfetch-cli/fastfetch) terminal system info — used as a fancy MOTD / shell-startup banner. Custom Arch ASCII logo and a slim cyberpunk-pink/cyan color palette.

## Files

| File | Purpose |
| --- | --- |
| [config.jsonc](config.jsonc) | Modules, layout, color tokens |
| [arch.txt](arch.txt) | Custom ASCII art logo (9 lines) used as the `logo.source` |

## Modules shown

In order, from [config.jsonc](config.jsonc):

1. **title** — `user@host` (pink user/at, cyan host)
2. **os** — distro name
3. **kernel** — kernel version
4. **host** — machine model (formatted as `{vendor} {name}`)
5. **packages** — pacman package count
6. **cpu** — CPU model (cores trimmed from output via the `{2}` format)
7. **memory** — used / total

Two `break` separators above the title and one below the memory line add breathing room around the block.

## Palette

Defined inline in [config.jsonc](config.jsonc):

| Token | Hex |
| --- | --- |
| Pink (logo color 1, primary keys) | `#FF6B9D` |
| Cyan (logo color 2, title) | `#4ECDC4` |
| Magenta (logo color 3, host) | `#E91E63` |
| Blue (kernel key, logo color 4) | `#2196F3` |
| Pink alt (logo color 5) | `#FF6B9D` |

## Usage

Add to your shell rc to run on terminal launch:

```bash
# ~/.bashrc or ~/.zshrc
fastfetch
```

Or invoke explicitly: `fastfetch --config ~/.config/fastfetch/config.jsonc`

## Custom logo

[arch.txt](arch.txt) is a 9-line ASCII variant referenced via `logo.source` with 1px top padding. Replace it with any plain-text or sixel file to swap the banner; ANSI color codes inside the logo are mapped to `logo.color.1..5`.
