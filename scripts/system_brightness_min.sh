#!/bin/bash
_SET_BRIGHTNESS=10

$(echo $_SET_BRIGHTNESS|tee /sys/class/backlight/intel_backlight/brightness)