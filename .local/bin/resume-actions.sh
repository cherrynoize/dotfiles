#!/bin/sh

"$HOME/bin/screen-on" # turn screen back on

# wait for screen to be unlocked
# while pgrep screenlock; do sleep 3 > /dev/null; done

for i in $(seq 1 10); do
  /usr/bin/dunstctl set-paused false && break
  sleep 3
done &
