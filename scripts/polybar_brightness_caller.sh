#!/usr/bin/env sh

_COLOR_ON="ffbd2e"
_COLOR_OFF="ffffff"
_COLOR_KEYBOARD="dddddd"

_GET_BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/brightness)

process_redshift=$(pgrep -x redshift)

if [[ ! $process_redshift ]]; then
    echo -e "%{F#$_COLOR_OFF}   $_GET_BRIGHTNESS"
else
    echo -e "%{F#$_COLOR_ON}   $_GET_BRIGHTNESS"
fi
