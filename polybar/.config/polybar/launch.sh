#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
pkill -u "$UID" -f '[i]3_workspaces.sh'
pkill -u "$UID" -f '[i]3-msg -t subscribe \["workspace'

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
while pgrep -u "$UID" -f '[i]3_workspaces.sh' >/dev/null; do sleep 1; done
while pgrep -u "$UID" -f '[i]3-msg -t subscribe \["workspace' >/dev/null; do sleep 1; done

# Launch Polybar using modern config.ini
setsid -f polybar -c ~/.config/polybar/config.ini main >/tmp/polybar-main.log 2>&1
