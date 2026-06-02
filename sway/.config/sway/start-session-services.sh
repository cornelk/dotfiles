#!/usr/bin/env bash

set -euo pipefail

# Refresh the user manager and dbus activation environment for Wayland services.
dbus-update-activation-environment --systemd \
    DISPLAY \
    WAYLAND_DISPLAY \
    SWAYSOCK \
    XDG_CURRENT_DESKTOP=sway \
    XDG_SESSION_DESKTOP=sway \
    XDG_SESSION_TYPE=wayland

systemctl --user import-environment \
    DISPLAY \
    WAYLAND_DISPLAY \
    SWAYSOCK \
    XDG_CURRENT_DESKTOP \
    XDG_SESSION_DESKTOP \
    XDG_SESSION_TYPE

# If a user service activated the portal stack before sway exported Wayland vars,
# restart it now so Waybar and other portal clients see a healthy backend.
systemctl --user restart \
    xdg-desktop-portal.service \
    xdg-desktop-portal-wlr.service \
    xdg-desktop-portal-gtk.service || true
