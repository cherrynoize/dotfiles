#!/bin/sh
# actions to be run before system suspend
"$HOME/bin/notify-timer" -k 1111 2>/dev/null & # kill power management timers
/usr/bin/playerctl pause 2>/dev/null || true # stop music or ignore if not playing
dunstctl set-paused true & # pause notifications
/usr/bin/xset -dpms & # disable dpms
(screen-off & # turn off screen
  if which lockscreen >/dev/null 2>&1; then
    lockscreen & # lock screen
  fi
  sleep .3; # adjust sleep delay to avoid screenlock flashing before suspend
  screen-on)& # turn screen back on
