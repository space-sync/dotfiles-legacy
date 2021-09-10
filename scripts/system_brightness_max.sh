#!/usr/bin/env sh

_SET_BRIGHTNESS=937

$(echo $_SET_BRIGHTNESS|tee /sys/class/backlight/intel_backlight/brightness)
