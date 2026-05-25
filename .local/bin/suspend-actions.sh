#!/bin/sh
"$HOME/bin/notify-timer" -k 1111 2>/dev/null & # kill power management timers
/usr/bin/playerctl pause 2>/dev/null || true # stop music or ignore if not playing
/usr/bin/dunstctl set-paused true & # pause notifications
"$HOME/bin/screen-off" # turn screen off to prevent screenlock flashing
