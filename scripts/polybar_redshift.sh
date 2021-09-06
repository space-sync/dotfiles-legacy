#!/usr/bin/env zsh

process_redshift=$(pgrep -x redshift)

if [[ ! $process_redshift ]]; then
    #Turning on
    redshift &
else
    #Turning off
    killall redshift &
fi

#Change the theme mode
/usr/share/lord/scripts/system_theme_mode_switch.sh