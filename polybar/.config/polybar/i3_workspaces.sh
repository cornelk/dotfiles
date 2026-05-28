#!/usr/bin/env bash
# Custom i3 workspaces display that always shows 1-10

# Get active workspaces from i3
active=$(i3-msg -t get_workspaces | jq -r '.[].num')
focused=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).num')

# Icons for each workspace
icons=("" "" "" "" "" "" "" "" "" "")

output=""
for i in {1..10}; do
    icon="${icons[$((i-1))]}"

    # Check if workspace is focused
    if echo "$focused" | grep -q "^$i$"; then
        # Focused workspace
        output+="%{F#ebdbb2}%{B#458588} $i $icon %{B-}%{F-} "
    elif echo "$active" | grep -q "^$i$"; then
        # Active but not focused
        output+="%{F#ebdbb2} $i $icon %{F-} "
    else
        # Empty workspace
        output+="%{F#666666} $i $icon %{F-} "
    fi
done

echo "$output"
