#!/usr/bin/env sh

set -eu

# Keep this session from auto-locking via leftover idle daemons.
pkill -x swayidle >/dev/null 2>&1 || true
pkill -x xss-lock >/dev/null 2>&1 || true
pkill -x gnome-screensaver >/dev/null 2>&1 || true

if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.screensaver lock-enabled false >/dev/null 2>&1 || true
    gsettings set org.gnome.desktop.screensaver lock-delay 0 >/dev/null 2>&1 || true
    gsettings set org.gnome.desktop.session idle-delay 0 >/dev/null 2>&1 || true
fi
