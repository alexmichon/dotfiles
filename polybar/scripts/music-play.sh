#!/bin/bash

status=$(my-music status)
if [ "$?" != "0" ]; then
	echo ""
fi
if [[ "$status" == "Playing" ]]; then
	echo -n ""
elif [[ "$status" == "Paused" ]]; then
	echo -n "契"
else
	echo ""
fi
