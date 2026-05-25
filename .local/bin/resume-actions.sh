#!/bin/sh
# wait for screen to be locked
while ! pgrep screenlock; do sleep .3 > /dev/null; done

"$HOME/bin/screen-on" # turn screen back on

# wait for screen to be unlocked
# while pgrep screenlock; do sleep 3 > /dev/null; done

# /usr/bin/dunstctl set-paused false & # resume notifications
