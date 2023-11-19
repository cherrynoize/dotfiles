#!/usr/bin/env bash

case $1 in
  reload)
    pgrep polybar > /dev/null 2>&1 || exit;;
esac

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

# Launch bars
# You can append multiple log files (e.g: /tmp/polybarX.log /tmp/polybarY.log ...)
echo "---" | tee -a /tmp/polybar-main.log # /tmp/polybar-placeholder-main.log
polybar main 2>&1 | tee -a /tmp/polybar-main.log & disown
# polybar placeholder-main 2>&1 | tee -a /tmp/polybar-placeholder-main.log & disown

echo "Bar(s) launched..."

sleep 0.1 # Needs a moment
polybar-msg action "#wireless-network.module_hide"
polybar-msg action "#wired-network.module_hide"
polybar-msg action "#filesystem-root.module_hide"
echo "Toggled network module(s) visibility"
