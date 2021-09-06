#!/bin/bash

_BRIGHTNESS_CURRENT=$(cat /sys/class/backlight/intel_backlight/brightness)
_BRIGHTNESS_NORMAL=50
_BRIGHTNESS_MAX=937

if [ $_BRIGHTNESS_CURRENT -eq $_BRIGHTNESS_MAX ]; then
    _SET_BRIGHTNESS=$_BRIGHTNESS_NORMAL
elif [ $_BRIGHTNESS_CURRENT -ne $_BRIGHTNESS_MAX ]; then
    _SET_BRIGHTNESS=$_BRIGHTNESS_MAX
else
    notify-send "ERROR"
fi

$(echo $_SET_BRIGHTNESS|tee /sys/class/backlight/intel_backlight/brightness)