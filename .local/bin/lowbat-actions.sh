#!/bin/sh
"$HOME"/bin/notify-timer ' Battery exhausted' 'Suspending in $timers' 30 1 1111 && \
  /bin/systemd-run --user /bin/systemctl hibernate
