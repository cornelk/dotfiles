#!/usr/bin/env bash
# Custom i3 workspaces display that always shows 1-10.

render_workspaces() {
    local workspace_json binding_state mode active focused output icon i
    local -A active_workspaces=()

    workspace_json=$(i3-msg -t get_workspaces) || return
    binding_state=$(i3-msg -t get_binding_state 2>/dev/null)
    mode=$(jq -r '.name // "default"' <<< "$binding_state")

    while read -r active; do
        [[ -n "$active" ]] && active_workspaces["$active"]=1
    done < <(jq -r '.[].num' <<< "$workspace_json")

    focused=$(jq -r '.[] | select(.focused == true).num' <<< "$workspace_json")

    output=""
    if [[ "$mode" != "default" ]]; then
        output+="%{F#ebdbb2}%{B#cc241d} ${mode^^} %{B-}%{F-} "
    fi

    for i in {1..10}; do
        icon=""

        if [[ "$focused" == "$i" ]]; then
            output+="%{F#ebdbb2}%{B#458588} $i $icon %{B-}%{F-} "
        elif [[ -n "${active_workspaces[$i]}" ]]; then
            output+="%{F#ebdbb2} $i $icon %{F-} "
        else
            output+="%{F#666666} $i $icon %{F-} "
        fi
    done

    echo "$output"
}

render_workspaces

i3-msg -t subscribe '["workspace", "mode"]' | while read -r _; do
    render_workspaces
done
