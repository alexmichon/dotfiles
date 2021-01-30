#!/bin/bash

PID_DIR=/tmp/sxhkd
if [ ! -f $PID_DIR/current ]; then
	echo ""
	exit
fi

current=$(cat $PID_DIR/current)

if [[ "$current" != "default" ]]; then
	echo "${current^^}"
else
	echo ""
fi
