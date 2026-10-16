#!/usr/bin/env bash
set -euo pipefail

if ! command -v sudo >/dev/null 2>&1; then
    echo "error: sudo is required"
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$script_dir/../.." && pwd)"

packages=(
    blueman
    brightnessctl
    dex
    foot
    grim
    kanshi
    kitty
    mako-notifier
    network-manager-gnome
    pavucontrol
    policykit-1-gnome
    system-config-printer
    slurp
    sway
    swaybg
    swayidle
    swaylock
    thunar
    waybar
    wdisplays
    xclip
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

# Plain `sway` refuses to start on the proprietary NVIDIA driver, so register a
# session that uses the sway-session launcher (--unsupported-gpu, NVIDIA env,
# persistent log in ~/.local/state/sway/session.log).
# This repository does not contain the launcher. Skip the session if it is missing.
sway_session_launcher="$HOME/.local/bin/sway-session"
if [[ -d /proc/driver/nvidia ]]; then
    if [[ -x "$sway_session_launcher" ]]; then
        sudo tee /usr/share/wayland-sessions/sway-nvidia.desktop >/dev/null <<EOF
[Desktop Entry]
Name=Sway (NVIDIA)
Comment=Sway with --unsupported-gpu for the proprietary NVIDIA driver
Exec=$sway_session_launcher
Type=Application
DesktopNames=sway
EOF
        echo "Installed the 'Sway (NVIDIA)' session."
    else
        echo "warning: $sway_session_launcher is missing, skipped the 'Sway (NVIDIA)' session." >&2
    fi
fi

systemctl --user daemon-reload || true
systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP || true

echo "Sway dotfiles installed."
echo "Log out and choose the Sway session from the display manager."
