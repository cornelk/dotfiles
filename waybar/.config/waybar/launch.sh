#!/usr/bin/env bash

set -euo pipefail

WAYBAR_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/waybar/config"
WAYBAR_STYLE="${XDG_CONFIG_HOME:-$HOME/.config}/waybar/style.css"
WAYBAR_LOG="${XDG_CACHE_HOME:-$HOME/.cache}/waybar/launch.log"

mkdir -p "$(dirname "$WAYBAR_LOG")"

pkill -x waybar 2>/dev/null || true
exec waybar -c "$WAYBAR_CONFIG" -s "$WAYBAR_STYLE" >"$WAYBAR_LOG" 2>&1
