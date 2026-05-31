#!/usr/bin/env bash

set -euo pipefail

state_dir="${XDG_RUNTIME_DIR:-/tmp}/sway-focus-history"
state_file="$state_dir/last-windows"

focused_window_info() {
    swaymsg -t get_tree | jq -r '.. | objects | select((.type == "con" or .type == "floating_con") and .focused? == true) | "\(.id)|\(.app_id // .window_properties.class // "" )"' | head -n 1
}

app_for_id() {
    local id=$1
    swaymsg -t get_tree | jq -r --argjson id "$id" '.. | objects | select((.type == "con" or .type == "floating_con") and .id == $id) | "\(.app_id // .window_properties.class // "" )"' | head -n 1
}

container_exists() {
    local id=$1
    swaymsg -t get_tree | jq -e --argjson id "$id" '.. | objects | select((.type == "con" or .type == "floating_con") and .id? == $id)' >/dev/null
}

record_focus() {
    local id=$1 app=$2
    local line=""
    local -a history=()

    [[ -n "$id" ]] || return 0
    [[ -n "$app" ]] || return 0

    mkdir -p "$state_dir"

    if [[ -f "$state_file" ]]; then
        mapfile -t history < "$state_file"
    fi

    if [[ "${history[0]:-}" == "$app|$id" ]]; then
        return 0
    fi

    {
        printf '%s|%s\n' "$app" "$id"
        for line in "${history[@]}"; do
            [[ -n "$line" ]] || continue
            [[ "$line" == "$app|$id" ]] && continue
            printf '%s\n' "$line"
            break
        done
    } > "$state_file.tmp"

    mv "$state_file.tmp" "$state_file"
}

daemon() {
    mkdir -p "$state_dir"
    exec 9>"$state_dir/daemon.lock"
    flock -n 9 || exit 0

    current_info="$(focused_window_info)"
    record_focus "${current_info%%|*}" "${current_info#*|}"

    swaymsg -m -t subscribe '["window"]' | while IFS= read -r event; do
        id=$(jq -r 'select(.change == "focus") | .container.id // empty' <<< "$event")
        [[ -z "$id" ]] && continue

        app=$(jq -r 'select(.change == "focus") | .container.app_id // .container.window_properties.class // empty' <<< "$event")
        if [[ -z "$app" ]]; then
            app="$(app_for_id "$id")"
        fi
        record_focus "$id" "$app"
    done
}

toggle() {
    local current_info=""
    local current_id=""
    local current_app=""
    local target_app=""
    local target_id=""
    local -a history=()

    [[ -f "$state_file" ]] || exit 0
    mapfile -t history < "$state_file"
    [[ "${#history[@]}" -ge 2 ]] || exit 0

    current_info="$(focused_window_info)"
    current_id="${current_info%%|*}"
    current_app="${current_info#*|}"

    IFS='|' read -r target_app target_id <<< "${history[1]:-}"
    [[ -n "$target_app" && -n "$target_id" ]] || exit 0

    [[ "$target_id" != "$current_id" ]] || exit 0

    if ! container_exists "$target_id"; then
        target_id="$(swaymsg -t get_tree | jq -r --arg app "$target_app" '.. | objects | select((.type == "con" or .type == "floating_con") and ((.app_id? == $app) or (.window_properties.class? == $app))) | .id' | head -n 1)"
        [[ -n "$target_id" ]] || exit 0
    fi

    container_exists "$target_id" || exit 0

    if swaymsg "[con_id=$target_id]" focus >/dev/null; then
        {
            printf '%s|%s\n' "$target_app" "$target_id"
            printf '%s|%s\n' "$current_app" "$current_id"
        } > "$state_file.tmp"
        mv "$state_file.tmp" "$state_file"
    fi
}

case "${1:-toggle}" in
    --daemon)
        daemon
        ;;
    --toggle|--toggle-app|toggle)
        toggle
        ;;
    *)
        echo "usage: $0 [--daemon|--toggle]" >&2
        exit 2
        ;;
esac
