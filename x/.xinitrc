#!/bin/sh

# Load Xft.dpi and font rendering settings before starting desktop apps.
[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"

# GTK/GDK scaling. Xft.dpi handles HiDPI; this keeps GTK text from getting huge.
export GDK_SCALE=1
export GDK_DPI_SCALE=0.75

# Disable screen going black
xset s off
xset -dpms
xset s noblank

# Turn off screen after 60m
xset s 3600 3600

# Set keyboard layout
setxkbmap -option 'grp:win_space_toggle' -layout us,us -variant colemak,

# Disable touchpad middle button
if command -v xinput >/dev/null 2>&1; then
    xinput list --name-only | while IFS= read -r device; do
        case "$device" in
            *Touchpad*|*Trackpad*|*TrackPoint*)
                button_map=$(xinput get-button-map "$device" 2>/dev/null) || continue
                # shellcheck disable=SC2086
                set -- $button_map
                [ "$#" -ge 3 ] || continue

                new_button_map=""
                index=1
                for button in "$@"; do
                    if [ "$index" -eq 2 ]; then
                        button=0
                    fi

                    new_button_map="${new_button_map}${new_button_map:+ }$button"
                    index=$((index + 1))
                done

                # shellcheck disable=SC2086
                xinput set-button-map "$device" $new_button_map 2>/dev/null || true
                ;;
        esac
    done
fi

# Set mouse speed
xset m 3/1 8

# remap caps lock
setxkbmap -option ctrl:nocaps

[ -f "$HOME/.Xmodmap" ] && xmodmap "$HOME/.Xmodmap"

[ -f "$HOME/bin/layout.sh" ] && bash "$HOME/bin/layout.sh"
