#!/usr/bin/env bash
set -euo pipefail

if ! command -v sudo >/dev/null 2>&1; then
    echo "error: sudo is required"
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$script_dir/../.." && pwd)"

packages=(
    brightnessctl
    dex
    grim
    kanshi
    kitty
    mako-notifier
    network-manager-gnome
    pavucontrol
    policykit-1-gnome
    slurp
    sway
    swaybg
    swayidle
    swaylock
    thunar
    waybar
    wdisplays
    wl-clipboard
    wofi
    xdg-desktop-portal-wlr
)

sudo apt-get update
sudo apt-get install -y "${packages[@]}"

if ! command -v stow >/dev/null 2>&1; then
    sudo apt-get install -y stow
fi

mkdir -p "$HOME/Pictures/Screenshots"

cd "$repo_dir"
stow -t "$HOME" sway waybar wofi mako swaylock environment kitty

systemctl --user daemon-reload || true
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP || true

echo "Sway dotfiles installed."
echo "Log out and choose the Sway session from the display manager."
