#!/bin/sh
# after system resume from sleep
if which lockscreen >/dev/null 2>&1; then
  lockscreen &

  if [ "$(get-display-server)" = "wayland" ]; then
    sleep .65
  else
    sleep .3
  fi
fi
screen-on # turn screen back on

# wait until screen is unlocked
while pgrep lockscreen; do sleep 3 > /dev/null; done

dunstctl set-paused false & # resume notifications
