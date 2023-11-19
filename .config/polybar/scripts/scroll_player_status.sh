#!/usr/bin/env bash

get_status="$(dirname $0)/get_player_status.sh"

# see man zscroll for documentation of the following parameters
zscroll -l 28 \
        --delay 0.1 \
        --scroll-padding "  " \
        --match-command "${get_status} --status" \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 0" \
        --update-check=true "${get_status}" &
wait
