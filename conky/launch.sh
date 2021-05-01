#!/bin/bash

CONKY_DIR=$HOME/.config/conky

killall -q conky

while pgrep -u $UID -x conky > /dev/null; do sleep 1; done

LOG_DIR="$HOME/.log/conky"
mkdir -p $LOG_DIR

INSTANCE_DIR=$CONKY_DIR/$(hostname)
if [ ! -d $INSTANCE_DIR ]; then
	echo "Directory $INSTANCE_DIR doesn't exist"
	exit 1
fi

for file in $(ls $INSTANCE_DIR/*); do
	echo $file
	instance=$(basename "$file" ".conf")
	conky -c $file > $LOG_DIR/$instance.log 2>&1 &
	sleep .5
done
