#!/bin/sh

"$HOME/bin/screen-on" # turn screen back on

# wait for screen to be unlocked
# while pgrep screenlock; do sleep 3 > /dev/null; done

if pidof dunst; then
  for i in $(seq 1 10); do
    sleep 3
    /usr/bin/dunstctl set-paused false && break
  done &
fi
