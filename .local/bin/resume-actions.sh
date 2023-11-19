#!/bin/sh
# actions to be run after system resume
# (only useful if locker utility doesn't fork)
dunstctl set-paused false & # resume notifications
/usr/bin/xset +dpms # re-enable dpms
