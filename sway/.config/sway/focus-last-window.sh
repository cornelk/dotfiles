#!/usr/bin/env bash
set -euo pipefail

state_dir="${XDG_RUNTIME_DIR:-/tmp}/sway-focus-history"
state_file="$state_dir/last-windows"

current_focused_id() {
    swaymsg -t get_tree | jq -r '.. | objects | select(.focused? == true) | .id' | head -n 1
}

container_exists() {
    local id=$1
    swaymsg -t get_tree | jq -e --argjson id "$id" '.. | objects | select(.id? == $id)' >/dev/null
}

record_focus() {
    local id=$1 current="" previous=""

    [[ -n "$id" ]] || return 0
    mkdir -p "$state_dir"

    if [[ -f "$state_file" ]]; then
        mapfile -t history < "$state_file"
        current="${history[0]:-}"
        previous="${history[1]:-}"
    fi

    [[ "$id" != "$current" ]] || return 0

    {
        printf '%s\n' "$id"
        [[ -n "$current" ]] && printf '%s\n' "$current"
        [[ -n "$previous" && "$previous" != "$id" && "$previous" != "$current" ]] && printf '%s\n' "$previous"
    } > "$state_file.tmp"

    mv "$state_file.tmp" "$state_file"
}

daemon() {
    mkdir -p "$state_dir"
    exec 9>"$state_dir/daemon.lock"
    flock -n 9 || exit 0

    record_focus "$(current_focused_id)"

    swaymsg -t subscribe '["window"]' | while IFS= read -r event; do
        id=$(jq -r 'select(.change == "focus") | .container.id // empty' <<< "$event")
        record_focus "$id"
    done
}

toggle() {
    [[ -f "$state_file" ]] || exit 0

    mapfile -t history < "$state_file"
    target="${history[1]:-}"

    [[ -n "$target" ]] || exit 0

    if container_exists "$target"; then
        swaymsg "[con_id=$target]" focus >/dev/null
    fi
}

case "${1:-toggle}" in
    --daemon)
        daemon
        ;;
    --toggle|toggle)
        toggle
        ;;
    *)
        echo "usage: $0 [--daemon|--toggle]" >&2
        exit 2
        ;;
esac
