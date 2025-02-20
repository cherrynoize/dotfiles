#!/bin/sh
# actions to be run before system suspend
"$HOME/bin/notify-timer" -k 1111 2>/dev/null & # kill power management timers
/usr/bin/playerctl pause 2>/dev/null || true # stop music or ignore if not playing
dunstctl set-paused true & # pause notifications
screen-off & # turn off screen
