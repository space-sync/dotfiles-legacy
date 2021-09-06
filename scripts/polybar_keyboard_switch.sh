#!/usr/bin/env zsh

_CAPS_LOCK=$(xset q | grep Caps | awk '{print $4}')
_NUM_LOCK=$(xset q | grep Num | awk '{print $8}')
_SCROLL_LOCK=$(xset q | grep Scroll | awk '{print $12}')

#Every one "on"
if [[ $_CAPS_LOCK == "on" && $_NUM_LOCK == "on" && $_SCROLL_LOCK == "on" ]]; then
    xdotool key Caps_Lock && xdotool key Num_Lock && xdotool key Scroll_Lock

#Two "on"
elif [[ $_CAPS_LOCK == "on" && $_NUM_LOCK == "on" && $_SCROLL_LOCK == "off" ]]; then
    xdotool key Scroll_Lock
elif [[ $_CAPS_LOCK == "on" && $_NUM_LOCK == "off" && $_SCROLL_LOCK == "on" ]]; then
    xdotool key Num_Lock
elif [[ $_CAPS_LOCK == "off" && $_NUM_LOCK == "on" && $_SCROLL_LOCK == "on" ]]; then
    xdotool key Caps_Lock

#One "on"
elif [[ $_CAPS_LOCK == "on" && $_NUM_LOCK == "off" && $_SCROLL_LOCK == "off" ]]; then
    xdotool key Num_Lock && xdotool key Scroll_Lock
elif [[ $_CAPS_LOCK == "off" && $_NUM_LOCK == "on" && $_SCROLL_LOCK == "off" ]]; then
    xdotool key Caps_Lock && xdotool key Scroll_Lock
elif [[ $_CAPS_LOCK == "off" && $_NUM_LOCK == "off" && $_SCROLL_LOCK == "on" ]]; then
    xdotool key Caps_Lock && xdotool key Num_Lock

#No one "on"
elif [[ $_CAPS_LOCK == "off" && $_NUM_LOCK == "off" && $_SCROLL_LOCK == "off" ]]; then
    xdotool key Caps_Lock && xdotool key Num_Lock && xdotool key Scroll_Lock
fi