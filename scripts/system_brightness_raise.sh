#!/usr/bin/env sh

_INCREMENT=5

_GET_BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/brightness)

_SET_BRIGHTNESS=$[$_GET_BRIGHTNESS+$_INCREMENT]

$(echo $_SET_BRIGHTNESS|tee /sys/class/backlight/intel_backlight/brightness)
