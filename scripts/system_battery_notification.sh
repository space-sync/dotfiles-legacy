#!/usr/bin/env sh

#xbacklight -inc 10 && notify-send -u low -t 1500 "Brightness Up $ICON_UP"
#notify-send --urgency=critical --icon=battery-caution "Full charged. Remove the charger"

#notify-send -u low -t 1500 --urgency=critical --icon=battery-caution "Full charged. Remove the charger"

_battery(){
	_BATTERY_PERCENTAGE=$(acpi -b | grep -E -o '[0-9][0-9]?%')
	_BATTERY_REMAINING=$(acpi -b | grep -E -o '[0-9][0-9]:[0-9][0-9]:[0-9][0-9]?')
	_LEVEL=$(cat /sys/class/power_supply/BAT1/capacity)
	_STATUS=$(cat /sys/class/power_supply/BAT1/status)

    _BATTERY_CHARGED_LOW="Low battery. Connect the charger $_LEVEL%"
    _BATTERY_CHARGED_FULL="Full charged. Remove the charger $_LEVEL%"

	if [[ "$_STATUS" != "Charging" && $_LEVEL -lt 30 ]] ; then
        #notify-send --urgency=critical --icon=battery-caution "$_BATTERY_CHARGED_LOW" "Remaining: $_BATTERY_REMAINING"
        notify-send -u low -t 1500 --urgency=critical --icon=battery-caution "$_BATTERY_CHARGED_LOW" "Remaining: $_BATTERY_REMAINING"
    elif [[ "$_STATUS" == "Charging" && $_LEVEL -eq 100 ]] ; then
        notify-send --urgency=critical --icon=battery-caution "$_BATTERY_CHARGED_FULL"
    fi
}

while :
do
    _battery
	sleep 10
done
