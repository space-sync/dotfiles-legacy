#!/usr/bin/env sh

#PATH_SCRIPT="$(dirname "$(readlink -f "$0")")"

#############################
#Declaring variables
#############################

AUX1=$1
AUX2=$2

TERMINAL_COLOR_ON="FFDB2E"
TERMINAL_COLOR_OFF="FFFFFF"
TERMINAL_COLOR_KEYBOARD="DDDDDD"

BRIGHTNESS_PATH="/sys/class/backlight/intel_backlight/brightness"
BRIGHTNESS_CURRENT=$(cat $BRIGHTNESS_PATH)
BRIGHTNESS_DIFF=10
BRIGHTNESS_DECREASE=$BRIGHTNESS_DIFF
BRIGHTNESS_INCREASE=$BRIGHTNESS_DIFF
BRIGHTNESS_MAX=937
BRIGHTNESS_MIN=10
BRIGHTNESS_NORMAL=50

PROCESS_REDSHIFT=$(pgrep -x redshift)

REDSHIFT_FILE_LAST_COLOR="/tmp/redshift_last_color.log"
REDSHIFT_COLOR_DIFF=300
REDSHIFT_COLOR_NEUTRAL=6500

MESSAGE_HELP="
\t\t\t\tSystem brightness controller
\t\t\t\t----------------------------\n
[Description]
Change the system brightness value from the operating system.

[Dependencies]
Redshift

[Parameters]
-h\t\t--help\t-?\t\t\tDisplay this help message
-e\t\t--edit\t\t\t\tEdit this script file
--chown\t\t--brightness-permission\t\tChange the brightness permission file (ONLY ROOT)
--get\t\t--brightness-current\t\tGet the current brightness value from system
--down\t\t--brightness-decrease\t\tDecrease $BRIGHTNESS_DIFF values to system brightness
--up\t\t--brightness-increase\t\tIncrease $BRIGHTNESS_DIFF values to sytem brighness
--max\t\t--brightness-max\t\tSet the maximal value to system brightness
--min\t\t--brightness-min\t\tSet the minimal value to system brightness
--set\t\t--brightness-manual\t\tSet a specific value to system brightness
--toogle\t--brightness-toogle\t\tToogle system brightness values between $BRIGHTNESS_NORMAL and $BRIGHTNESS_MAX values
--filter\t--brightness-screen-filter-toogle\tToogle enable/disable screen filter

[Examples]
sudo $0 --chown your_username
$0 --get
$0 --up
$0 --down
$0 --set 457
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_HELP"

#############################
#Functions
#############################

display_message(){
	echo -e "$1"
}

display_message_debug(){
	echo -e "
#############################
\t\t\tDebugging values
\t\t\t----------------\n
[Global values]
Brightness path file:\t\t$BRIGHTNESS_PATH
Brightness last value:\t\t$BRIGHTNESS_CURRENT
Brightness decrease value:\t$BRIGHTNESS_DECREASE
Brightness inclease value:\t$BRIGHTNESS_INCREASE
Brightness max value:\t\t$BRIGHTNESS_MAX
Brightness min value:\t\t$BRIGHTNESS_MIN
Brightness normal value:\t$BRIGHTNESS_NORMAL

[Local values]
Brightness set:\t\t\t$1
#############################
"
}

brightness_apply(){
	display_message_debug "$1"

	#Verify if the brightness to be applied is a valid value
	if [[ $1 -lt $BRIGHTNESS_MIN ]]; then
		echo $BRIGHTNESS_MIN > $BRIGHTNESS_PATH
	elif [[ $1 -gt $BRIGHTNESS_MAX ]]; then
		echo $BRIGHTNESS_MAX > $BRIGHTNESS_PATH
	else
		echo $1 > $BRIGHTNESS_PATH
	fi
}

brightness_get_current(){
	local BASE_PERCENT=$((100/2))
	local BASE_VALUE=$(($BRIGHTNESS_MAX/2))
	local BRIGHTNESS_PERCENT=$(($BRIGHTNESS_CURRENT*$BASE_PERCENT/$BASE_VALUE))

	if [[ ! $PROCESS_REDSHIFT ]]; then
		display_message "%{F#$TERMINAL_COLOR_OFF}   $BRIGHTNESS_PERCENT %"
		#display_message "%{F#$TERMINAL_COLOR_OFF}   $BRIGHTNESS_PERCENT % | $BRIGHTNESS_CURRENT"
	else
		local REDSHIFT_CURRENT_COLOR=$(brightness_screen_filter_get_last_color)
		display_message "%{F#$TERMINAL_COLOR_ON}   $BRIGHTNESS_PERCENT % | $REDSHIFT_CURRENT_COLOR K"
		#display_message "%{F#$TERMINAL_COLOR_ON}   $BRIGHTNESS_PERCENT % | $BRIGHTNESS_CURRENT"
	fi
}

brightness_set_decrease(){
	local BRIGHTNESS_SET=$(($BRIGHTNESS_CURRENT-$BRIGHTNESS_DECREASE))
	brightness_apply "$BRIGHTNESS_SET"
}

brightness_set_increase(){
	local BRIGHTNESS_SET=$(($BRIGHTNESS_CURRENT+$BRIGHTNESS_INCREASE))
	brightness_apply "$BRIGHTNESS_SET"
}

brightness_set_max(){
	local BRIGHTNESS_SET=$BRIGHTNESS_MAX
	brightness_apply "$BRIGHTNESS_SET"
}

brightness_set_min(){
	local BRIGHTNESS_SET=$BRIGHTNESS_MIN
	brightness_apply "$BRIGHTNESS_SET"
}

brightness_set_manual(){
	local BRIGHTNESS_SET=$AUX2
	brightness_apply "$BRIGHTNESS_SET"
}

brightness_toogle(){
	if [[ $BRIGHTNESS_CURRENT -eq $BRIGHTNESS_MAX ]]; then
		local BRIGHTNESS_SET=$BRIGHTNESS_NORMAL
	elif [[ $BRIGHTNESS_CURRENT -ne $BRIGHTNESS_MAX ]]; then
		local BRIGHTNESS_SET=$BRIGHTNESS_MAX
	else
		echo -e "$MESSAGE_ERROR"
	fi

	brightness_apply "$BRIGHTNESS_SET"
}

brightness_screen_filter_toogle(){
	#Checking if Redshift process is running
	if [[ $PROCESS_REDSHIFT ]]; then
		killall -9 redshift &
	else
		redshift &
	fi
}

#MUST BE TESTED
brightness_permission(){
	if [[ $UID != 0 ]]; then
		display_message "You must have ROOT previledges for proceduring"
		exit
	else
		chown $AUX2:$AUX2 $BRIGHTNESS_PATH
	fi
}

####################################################################################################

brightness_screen_filter_get_last_color(){
	#Check if $REDSHIFT_FILE_LAST_COLOR file exists
	if [[ -f $REDSHIFT_FILE_LAST_COLOR ]]; then
		local REDSHIFT_LAST_COLOR=$(cat $REDSHIFT_FILE_LAST_COLOR)
	else
		brightness_screen_filter_reset
		local REDSHIFT_LAST_COLOR=$REDSHIFT_COLOR_NEUTRAL
	fi

	echo "$REDSHIFT_LAST_COLOR"
}

brightness_screen_filter_write_last_color(){
	if [[ -f $REDSHIFT_FILE_LAST_COLOR ]]; then
		echo -e "$1" > $REDSHIFT_FILE_LAST_COLOR
	else
		touch $REDSHIFT_FILE_LAST_COLOR
		echo -e "$1" > $REDSHIFT_FILE_LAST_COLOR
	fi
}

brightness_screen_filter_validate_value(){
	#Validate the newest color value
	if [ "$1" -gt 1000 ] && [ "$1" -lt 25000 ]; then
		redshift -O $1
		brightness_screen_filter_write_last_color $REDSHIFT_COLOR_NEUTRAL
	else
		echo "$1 is not a valid number for Redshift temperature scale"
		exit
	fi
}

#MUST BE TESTED
brightness_screen_filter_reset(){
	#Check if Redshift process is running
	if [[ $PROCESS_REDSHIFT ]]; then
		#Only increase/decrease screen filter if Redshift is enabled
		redshift -x
		brightness_screen_filter_write_last_color $REDSHIFT_COLOR_NEUTRAL
	fi
}

#MUST BE TESTED
brightness_screen_filter_increase(){
	brightness_screen_filter_reset
	local REDSHIFT_LAST_COLOR=$(brightness_screen_filter_get_last_color)
	local REDSHIFT_COLOR_NEWEST=$(($REDSHIFT_LAST_COLOR+$REDSHIFT_COLOR_DIFF))
	brightness_screen_filter_validate_value $REDSHIFT_COLOR_NEWEST
}

#MUST BE TESTED
brightness_screen_filter_decrease(){
	brightness_screen_filter_reset
	local REDSHIFT_LAST_COLOR=$(brightness_screen_filter_get_last_color)
	local REDSHIFT_COLOR_NEWEST=$(($REDSHIFT_LAST_COLOR-$REDSHIFT_COLOR_DIFF))
	brightness_screen_filter_validate_value $REDSHIFT_COLOR_NEWEST
}

#############################
#Dedicated functions for Polybar
#############################

polybar_display(){
	brightness_get_current
}

polybar_click_left(){
	brightness_screen_filter_increase
}

polybar_click_middle(){
    brightness_screen_filter_toogle
}

polybar_click_right(){
	brightness_screen_filter_decrease
}

polybar_double_click_left(){
    :
}
    
polybar_double_click_middle(){
    :
}
    
polybar_double_click_right(){
    :
}

polybar_scroll_up(){
	brightness_set_increase
}

polybar_scroll_down(){
	brightness_set_decrease
}

#############################
#Calling the functions
#############################

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;;
	"--chown" | "--brightness-permission") brightness_permission ;;
	"--get" | "--brightness-current") brightness_get_current ;;
	"--down" | "--brightness-decrease") brightness_set_decrease ;;
	"--up" | "--brightness-increase") brightness_set_increase ;;
	"--max" | "--brightness-max") brightness_set_max ;;
	"--min" | "--brightness-min") brightness_set_min ;;
	"--set" | "--brightness-manual") brightness_set_manual ;;
	"--toogle" | "--brightness-toogle") brightness_toogle ;;
	"--filter" | "--brightness-screen-filter-toogle") brightness_screen_filter_toogle ;;
	#brightness_screen_filter_get_last_color
	#brightness_screen_filter_write_last_color
	#brightness_screen_filter_validate_value
	#brightness_screen_filter_reset
	#brightness_screen_filter_increase
	#brightness_screen_filter_decrease
	
	#Calling the dedicate Polybar functions
    "--polybar-display") polybar_display ;;
    "--polybar-click-left") polybar_click_left ;;
    "--polybar-click-middle") polybar_click_middle ;;
    "--polybar-click-right") polybar_click_right ;;
    "--polybar-double-click-left") polybar_double_click_left ;;
    "--polybar-double-click-middle") polybar_double_click_middle ;;
    "--polybar-double-click-right") polybar_double_click_right ;;
	"--polybar-scroll-up") polybar_scroll_up ;;
	"--polybar-scroll-down") polybar_scroll_down ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac