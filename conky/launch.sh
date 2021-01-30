#!/bin/bash

killall -q conky

while pgrep -u $UID -x conky > /dev/null; do sleep 1; done

WINDOWS=( \
"date" \
"sidebar" \
"calendar-icon" \
"calendar" \
"weather" \
)

LOG_DIR="$HOME/.log/conky"
mkdir -p $LOG_DIR

for window in "${WINDOWS[@]}"; do
	conky -c $HOME/.config/conky/$window.conf > $LOG_DIR/$window.log 2>&1 &
	sleep .2
done
