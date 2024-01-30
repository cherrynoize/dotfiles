#!/usr/bin/env bash

# polybar bar which houses the main player and control modules
polybar_parent_bar_name="main"
polybar_parent_bar_pid="$(pgrep -a "polybar" | grep "$polybar_parent_bar_name" | cut -d" " -f1)"

# sends $2 as message to all polybar pids that are part of $1
update_hooks () {
  while IFS= read -r id
  do
    polybar-msg -p "$id" hook player-play-pause "$2" 1>/dev/null 2>&1
  done < <(echo "$1")
}

# update polybar hooks
case "$(music status)" in
  stopped|Paused|"no player")
    update_hooks "$polybar_parent_bar_pid" 2
    ;;
  *)
    update_hooks "$polybar_parent_bar_pid" 1
    ;;
esac

music "$@"
