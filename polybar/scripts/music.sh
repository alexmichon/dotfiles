#!/bin/bash

status=$(my-music status)
if [[ "$status" == "Playing" ]] || [[ "$status" == "Paused" ]]; then
	echo "$(my-music show)"
else
	echo ""
fi
