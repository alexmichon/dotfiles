#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

BARS=( \
power \
wm \
music \
sxhkd \
tray \
icons \
date \
)

PID_DIR=/tmp/polybar
LOG_DIR="$HOME/.log/polybar"
if [ ! -d $LOG_DIR ]; then
	mkdir -p $LOG_DIR
fi

rm -r $PID_DIR
mkdir -p $PID_DIR
for bar in "${BARS[@]}"; do
	polybar -r $bar &
	echo "$!" > $PID_DIR/$bar.pid
done

EXTERNAL_MONITOR="DP-1"
EXTERNAL_PRESENT=$(xrandr --query | grep "$EXTERNAL_MONITOR")
if [[ $EXTERNAL_PRESENT == *connected* ]]; then
	for bar in "${BARS[@]}"; do
		MONITOR=$EXTERNAL_MONITOR polybar -r $bar-external > $LOG_DIR/$bar.log 2>&1 &
		echo "$!" > $PID_DIR/$bar-external.pid
	done
fi
