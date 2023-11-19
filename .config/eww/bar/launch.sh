#!/bin/bash

config="$HOME/.config/eww/bar/themes/current"
EWW="eww -c $config"

case "$1" in
  status)
    exec ${EWW} ping
    ;;
  reload)
    # kill eww so we can reload bar
    ${EWW} kill
    ;;
  close)
    # close everything
    ${EWW} kill
    bspc config top_padding 50
  # # ensure eww is dead
  # [ "$(pgrep eww)" ] &&
  #   killall eww
    exit
    ;;
esac

# run eww daemon if not already running
if [ ! "$(${EWW} ping)" ]; then
  ${EWW} daemon || exit 1
fi

# source config and launch widgets
. "$config/launch.sh"
