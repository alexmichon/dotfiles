#!/bin/bash

status=$(my-music status)
if [[ "$status" == "Playing" ]] || [[ "$status" == "Paused" ]]; then
	echo "玲"
else
	echo ""
fi
