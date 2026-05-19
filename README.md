# linux-rice

My personal Arch Linux rice — a **cyberpunk / synthwave** themed Hyprland setup.

Palette: hot pink `#ff4081`, electric cyan `#64c8ff`, purple `#c896ff` on a dark `#16162a` base.

## Components

| Folder | Tool | Purpose |
| --- | --- | --- |
| [hyprland/](hyprland/) | [Hyprland](https://hypr.land) | Tiling Wayland compositor — main desktop |
| [waybar/](waybar/) | [Waybar](https://github.com/Alexays/Waybar) | Top status bar |
| [rofi/](rofi/) | [Rofi](https://github.com/davatorium/rofi) | App launcher and dropdown menus |
| [dunst/](dunst/) | [dunst](https://dunst-project.org/) | Notification daemon |
| [kitty/](kitty/) | [kitty](https://sw.kovidgoyal.net/kitty/) | GPU-accelerated terminal |
| [fastfetch/](fastfetch/) | [fastfetch](https://github.com/fastfetch-cli/fastfetch) | Terminal system info with inline image logo |

## Stack

- **Compositor:** Hyprland
- **Bar:** Waybar
- **Launcher:** Rofi
- **Notifications:** dunst
- **Lockscreen:** hyprlock
- **Wallpaper:** hyprpaper / swww
- **Terminal:** kitty
- **Shell prompt fetch:** fastfetch
- **File manager:** dolphin
- **Browser:** brave
- **Font:** Hack Nerd Font / GohuFont 11 Nerd Font / Symbols Nerd Font

## Required packages (Arch)

```bash
sudo pacman -S hyprland hyprlock hyprpaper waybar rofi dunst kitty fastfetch \
               brightnessctl wireplumber playerctl networkmanager bluez bluez-utils \
               blueman grim slurp wl-clipboard ttf-hack-nerd dolphin

# AUR (via yay/paru)
yay -S swww nm-connection-editor
```

## Install

Symlink (or copy) the folders into `~/.config/`:

```bash
git clone https://github.com/Crepco/linux-rice.git
cd linux-rice

ln -s "$PWD/hyprland"  ~/.config/hypr       # note: target is "hypr", not "hyprland"
ln -s "$PWD/waybar"    ~/.config/waybar
ln -s "$PWD/rofi"      ~/.config/rofi
ln -s "$PWD/dunst"     ~/.config/dunst
ln -s "$PWD/kitty"     ~/.config/kitty
ln -s "$PWD/fastfetch" ~/.config/fastfetch
```

> The repo folder is named `hyprland/` for clarity, but Hyprland reads from `~/.config/hypr/`.

## Notes

- Wallpaper paths in [hyprland/hyprpaper.conf](hyprland/hyprpaper.conf), [hyprland/hyprlock.conf](hyprland/hyprlock.conf), and [rofi/config.rasi](rofi/config.rasi) hard-code `/home/crepco/...` — update them for your user.
- Waybar scripts under [waybar/scripts/](waybar/scripts/) also use absolute `/home/crepco/...` paths.
- Hyprland's clock module is set to `Asia/Kolkata` in [waybar/config.jsonc](waybar/config.jsonc).
- See each folder's `README.md` for component-specific details.
