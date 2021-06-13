#!/bin/sh

# Font settings
#mkdir $HOME/.fonts
#xset +fp $HOME/.fonts
#xset fp rehash

# Disable screen going black
xset s off
xset -dpms
xset s noblank

# Turn off screen after 60m
xset s 3600 3600

# Set keybord layout
setxkbmap -option 'grp:win_space_toggle' -layout us,us -variant colemak,

# Disable touchpad middle button
xinput set-button-map 12 1 0 3
xinput set-button-map 13 1 1 3

# Set mouse speed
xset m 3/1 8

# remap caps lock
setxkbmap -option ctrl:nocaps

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

bash bin/layout.sh
