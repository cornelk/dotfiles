#!/bin/sh

# GTK/GDK scaling to counteract high DPI setting
export GDK_SCALE=1
export GDK_DPI_SCALE=0.5

# Disable screen going black
xset s off
xset -dpms
xset s noblank

# Turn off screen after 60m
xset s 3600 3600

# Set keyboard layout
setxkbmap -option 'grp:win_space_toggle' -layout us,us -variant colemak,

# Disable touchpad middle button
if command -v xinput &> /dev/null; then
    xinput set-button-map 12 1 0 3
    xinput set-button-map 13 1 1 3
fi

# Set mouse speed
xset m 3/1 8

# remap caps lock
setxkbmap -option ctrl:nocaps

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

[[ -f ~/bin/layout.sh ]] && bash ~/bin/layout.sh
