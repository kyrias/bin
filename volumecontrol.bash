#!/usr/bin/env bash

if [[ -n "$2" ]]; then
	step=$2
else
	step=5
fi

case $1 in
	lower)
		amixer -D pulse -q set Master $step%-
		;;
	raise)
		amixer -D pulse -q set Master $step%+
		;;
	mute)
		amixer -D pulse -q set Master toggle
		;;
esac
