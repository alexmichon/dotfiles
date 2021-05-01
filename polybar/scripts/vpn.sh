#!/bin/sh

status=$(my-vpn status)
if [ "$status" == "up" ]; then
	echo ""
else
	echo ""
fi
