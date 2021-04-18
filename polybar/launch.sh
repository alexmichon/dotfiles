#!/bin/bash

POLYBAR_DIR=$HOME/.config/polybar

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

iface=$(my-interface)
monitors=$(xrandr | grep " connected" | awk '{print $1}')
primary=$(echo "$monitors" | grep "^e" | head -1)

PID_DIR=/tmp/polybar
LOG_DIR="$HOME/.log/polybar"
if [ ! -d $LOG_DIR ]; then
	mkdir -p $LOG_DIR
fi

rm -r $PID_DIR
mkdir -p $PID_DIR

if [ -d $POLYBAR_DIR/$(hostname) ]; then
	for bar in "${BARS[@]}"; do
		INTERFACE=$iface MONITOR=$primary polybar -r $bar-$(hostname) -c $POLYBAR_DIR/$(hostname)/config &
		echo "$!" > $PID_DIR/$bar.pid
	done
else
	for bar in "${BARS[@]}"; do
		INTERFACE=$iface MONITOR=$primary polybar -r $bar -c $POLYBAR_DIR/config &
		echo "$!" > $PID_DIR/$bar.pid
	done
fi

external=$(echo "$monitors" | grep -v "^e" | head -1)
if [[ -n $external && -d $POLYBAR_DIR/external-$(hostname) ]]; then
	for bar in "${BARS[@]}"; do
		INTERFACE=$iface MONITOR=$external polybar -r $bar-external-$(hostname) -c $POLYBAR_DIR/external-$(hostname)/config > $LOG_DIR/$bar.log 2>&1 &
		echo "$!" > $PID_DIR/$bar-external.pid
	done
fi
