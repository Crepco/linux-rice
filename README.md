# linux-rice

My personal Arch Linux rice — a **Yoake (夜明け)** themed Hyprland setup.

Palette: warm peach `#e2aaa1` and cream `#e9cdb0` cloud tones with cool slate `#7a8ca8` and sage `#90a89c` accents, on a deep night-slate `#20202f` base — a twilight/dawn mood. ("Yoake" is Japanese for *daybreak*.)

The desktop shell — bar, launcher, notifications, on-screen display, and lockscreen — is built entirely in [Quickshell](https://quickshell.org/) (QML); there is no separate bar/launcher/notification daemon.

## Components

| Folder | Tool | Purpose |
| --- | --- | --- |
| [hyprland/](hyprland/) | [Hyprland](https://hypr.land) | Tiling Wayland compositor — main desktop |
| [quickshell/](quickshell/) | [Quickshell](https://quickshell.org/) | Bar, app launcher, notifications, OSD, lockscreen, control popups |
| [kitty/](kitty/) | [kitty](https://sw.kovidgoyal.net/kitty/) | GPU-accelerated terminal |
| [fastfetch/](fastfetch/) | [fastfetch](https://github.com/fastfetch-cli/fastfetch) | Terminal system info with inline image logo |
| [gtk/](gtk/) | GTK | GTK theme overrides matching the palette |
| [btop/](btop/) | [btop](https://github.com/aristocratos/btop) | System monitor theme |
| [yazi/](yazi/) | [yazi](https://github.com/sxyazi/yazi) | Terminal file manager |

## Stack

- **Compositor:** Hyprland
- **Shell (bar / launcher / notifications / OSD / lockscreen):** Quickshell
- **Wallpaper:** swww (started via `awww` in [hyprland/hyprland.conf](hyprland/hyprland.conf))
- **Terminal:** kitty
- **Shell prompt fetch:** fastfetch
- **File manager:** yazi (TUI) / dolphin (GUI)
- **Browser:** brave
- **Font:** JetBrainsMono Nerd Font

## Required packages (Arch)

```bash
sudo pacman -S hyprland quickshell kitty fastfetch btop yazi \
               brightnessctl wireplumber playerctl networkmanager bluez bluez-utils \
               grim slurp wl-clipboard ttf-jetbrains-mono-nerd dolphin

# AUR (via yay/paru)
yay -S swww nm-connection-editor
```

> `nm-connection-editor` is used by the Quickshell Wi-Fi popup as a fallback for connecting to new secured networks.

## Install

Symlink the folders into `~/.config/`:

```bash
git clone https://github.com/Crepco/linux-rice.git
cd linux-rice

ln -s "$PWD/hyprland"  ~/.config/hypr       # note: target is "hypr", not "hyprland"
ln -s "$PWD/quickshell" ~/.config/quickshell
ln -s "$PWD/kitty"     ~/.config/kitty
ln -s "$PWD/fastfetch" ~/.config/fastfetch
ln -s "$PWD/gtk"       ~/.config/gtk-3.0     # adjust to your GTK setup
ln -s "$PWD/btop"      ~/.config/btop
ln -s "$PWD/yazi"      ~/.config/yazi
```

> The repo folder is named `hyprland/` for clarity, but Hyprland reads from `~/.config/hypr/`.

## Notes

- User-specific paths (wallpaper, etc.) are hard-coded for `/home/crepco/...` in [hyprland/hyprland.conf](hyprland/hyprland.conf) — update them for your user.
- Display output is `eDP-1` (internal laptop screen) — adjust for external monitors.
- See each folder's `README.md` for component-specific details.
