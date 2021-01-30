#!/bin/bash

status=$(my-music status)
if [[ "$status" == "Playing" ]] || [[ "$status" == "Paused" ]]; then
	echo "怜"
else
	echo ""
fi
