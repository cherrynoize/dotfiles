#!/bin/sh

#eww_dir="$HOME/.config/eww"
#config="${eww_dir:+"$eww_dir/themes/current"}"

eww_cmd () {
  eww ${config:+-c "$config"} "$@"
}

case "$1" in
  status)
    eww_cmd ping
    exit
    ;;
  reload)
    # kill eww so we can reload bar
    eww_cmd kill
    ;;
  close)
    # close everything
    eww_cmd kill
    exit
    ;;
esac

# run eww daemon if not already running
if ! eww_cmd ping; then
  eww_cmd daemon || exit 1
fi

eww_windows="bar"

if [ -n "$config" ]; then
  # source theme config
  . "$config/launch.sh"
fi

# open windows
eww_cmd open-many $eww_windows
