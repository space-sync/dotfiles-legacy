#!/usr/bin/env sh

_COLOR_ON="ffffff"
_COLOR_OFF="0a81f5"
_COLOR_KEYBOARD="dddddd"

keyboard_layout(){
    _KEYBOARD_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')
    echo "%{F#$_COLOR_KEYBOARD}$_KEYBOARD_LAYOUT"
}

locks_buttons_color(){
    _CAPS_LOCK=$(xset q | grep -i Caps | awk '{print $4}')
    _NUM_LOCK=$(xset q | grep -i Num | awk '{print $8}')
    _SCROLL_LOCK=$(xset q | grep -i Scroll | awk '{print $12}')

    #echo "%{F#ffffff}c%{F#ed0beb}N%{F#ffffff}s"

    #Every one "on"
    if [[ $_CAPS_LOCK == "on" && $_NUM_LOCK == "on" && $_SCROLL_LOCK == "on" ]]; then
        #_LOCKS_BUTTONS="%{F#$_COLOR_ON}C%{F#$_COLOR_ON}N%{F#$_COLOR_ON}S"
        _LOCKS_BUTTONS="%{F#$_COLOR_ON}C%{F#$_COLOR_ON}N%{F#$_COLOR_ON}S"

    #Two "on"
    elif [[ $_CAPS_LOCK == "on" && $_NUM_LOCK == "on" && $_SCROLL_LOCK == "off" ]]; then
        #_LOCKS_BUTTONS="%{F#$_COLOR_ON}C%{F#$_COLOR_ON}N%{F#$_COLOR_OFF}s"
        _LOCKS_BUTTONS="%{F#$_COLOR_ON}C%{F#$_COLOR_ON}N"
    elif [[ $_CAPS_LOCK == "on" && $_NUM_LOCK == "off" && $_SCROLL_LOCK == "on" ]]; then
        #_LOCKS_BUTTONS="%{F#$_COLOR_ON}C%{F#$_COLOR_OFF}n%{F#$_COLOR_ON}S"
        _LOCKS_BUTTONS="%{F#$_COLOR_ON}C%{F#$_COLOR_ON}S"
    elif [[ $_CAPS_LOCK == "off" && $_NUM_LOCK == "on" && $_SCROLL_LOCK == "on" ]]; then
        #_LOCKS_BUTTONS="%{F#$_COLOR_OFF}c%{F#$_COLOR_ON}N%{F#$_COLOR_ON}S"
        _LOCKS_BUTTONS="%{F#$_COLOR_ON}N%{F#$_COLOR_ON}S"

    #One "on"
    elif [[ $_CAPS_LOCK == "on" && $_NUM_LOCK == "off" && $_SCROLL_LOCK == "off" ]]; then
        #_LOCKS_BUTTONS="%{F#$_COLOR_ON}C%{F#$_COLOR_OFF}n%{F#$_COLOR_OFF}s"
        _LOCKS_BUTTONS="%{F#$_COLOR_ON}C"
    elif [[ $_CAPS_LOCK == "off" && $_NUM_LOCK == "on" && $_SCROLL_LOCK == "off" ]]; then
        #_LOCKS_BUTTONS="%{F#$_COLOR_OFF}c%{F#$_COLOR_ON}N%{F#$_COLOR_OFF}s"
        _LOCKS_BUTTONS="%{F#$_COLOR_ON}N"
    elif [[ $_CAPS_LOCK == "off" && $_NUM_LOCK == "off" && $_SCROLL_LOCK == "on" ]]; then
        #_LOCKS_BUTTONS="%{F#$_COLOR_OFF}c%{F#$_COLOR_OFF}n%{F#$_COLOR_ON}S"
        _LOCKS_BUTTONS="%{F#$_COLOR_ON}S"

    #No one "on"
    elif [[ $_CAPS_LOCK == "off" && $_NUM_LOCK == "off" && $_SCROLL_LOCK == "off" ]]; then
        #_LOCKS_BUTTONS="%{F#$_COLOR_OFF}c%{F#$_COLOR_OFF}n%{F#$_COLOR_OFF}s"
        _LOCKS_BUTTONS=""
    #else
    #    echo "Other"
    fi

    echo "$_LOCKS_BUTTONS"
}

_LOCKS_BUTTONS_COLOR=$(locks_buttons_color)
_KEYBOARD=$(keyboard_layout)

echo " $_KEYBOARD   $_LOCKS_BUTTONS_COLOR"

##echo "$_TIME"
#echo -n "%{F#ed0beb}$_TIME"
