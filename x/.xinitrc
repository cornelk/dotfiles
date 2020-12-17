#!/bin/sh

# Font settings
#mkdir fonts
#xset +fp $HOME/.fonts
#xset fp rehash

# Disable screen going black
xset s off
xset -dpms
xset s noblank

# Turn off screen after 15m
#xset s 900 1200

# Set keybord layout
setxkbmap -option 'grp:win_space_toggle' -layout us,us -variant colemak,

# Disable touchpad middle button
#xinput set-button-map 12 1 0 3

# Set mouse speed
xset m 3/1 8

# remap caps lock
setxkbmap -option ctrl:nocaps
xmodmap -e 'clear lock'
xmodmap -e 'keycode 66 = Hyper_L'

[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

bash bin/layout_ryzen.sh
