#!/usr/bin/env bash
# Symlink this rice into ~/.config — backs up anything it would replace.
set -euo pipefail

dir="$(cd "$(dirname "$0")" && pwd)"
stamp="$(date +%Y%m%d-%H%M%S)"

link() {
    local src="$dir/$1" dst="$HOME/.config/$2"
    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$src" ]; then
        echo "ok      $2 (already linked)"
        return
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mv "$dst" "$dst.bak-$stamp"
        echo "backup  $2 → $2.bak-$stamp"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "linked  $2 → $1"
}

link hyprland   hypr        # Hyprland reads ~/.config/hypr
link quickshell quickshell
link kitty      kitty
link fastfetch  fastfetch
link gtk        gtk-3.0
link btop       btop
link yazi       yazi

mkdir -p "$HOME/Pictures/Screenshots"   # screenshot binds save here

echo
echo "Done. Log out/in (or 'hyprctl reload') to apply."
echo "Wallpaper is expected at ~/Pictures/wallpapers/wallpaper.png"
