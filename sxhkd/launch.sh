#!/bin/bash

killall -q sxhkd

while pgrep -u $UID -x sxhkd > /dev/null; do sleep 1; done

# default must be last
MODES=( \
resize \
preselect \
default \
)

PID_DIR=/tmp/sxhkd

rm -rf $PID_DIR
mkdir -p $PID_DIR
for mode in "${MODES[@]}"; do
	sxhkd -c "$HOME/.config/sxhkd/sxhkdrc-$mode" &
	sleep 1
	pid=$!
	echo "$pid" > $PID_DIR/$mode.pid
	if [ "$mode"  != "default" ]; then
		kill -USR2 $pid
	fi
done

echo "default" > $PID_DIR/current
echo "default" > $PID_DIR/old
