#!/usr/bin/env sh

#PATH_SCRIPT="$(dirname "$(readlink -f "$0")")"
#Change the $BRIGHTNESS_PATH file owner 

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
BRIGHTNESS_DIFF=5
BRIGHTNESS_DECREASE=$BRIGHTNESS_DIFF
BRIGHTNESS_INCREASE=$BRIGHTNESS_DIFF
BRIGHTNESS_MAX=937
BRIGHTNESS_MIN=40
BRIGHTNESS_NORMAL=50

MESSAGE_HELP="
\t\t\t\tSystem brightness controller
\t\t\t\t----------------------------\n
[Description]
Change the system brightness value from the operating system.

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

[Examples]
sudo $0 --chown username
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
	if [[ $1 < $BRIGHTNESS_MIN ]]; then
		echo -e "Brightness value you are trying to set is under the min value"
		exit
	elif [[ $1 > $BRIGHTNESS_MAX ]]; then
		echo -e "Brightness value you are trying to set is above the max value"
		exit
	else
		#$(echo $1 | tee $BRIGHTNESS_PATH)
		echo $1 > $BRIGHTNESS_PATH
	fi
}

brightness_get_current(){
	PROCESS_REDSHIFT=$(pgrep -x redshift)

	if [[ ! $PROCESS_REDSHIFT ]]; then
		display_message "%{F#$TERMINAL_COLOR_OFF}   $BRIGHTNESS_CURRENT"
	else
		display_message "%{F#$TERMINAL_COLOR_ON}   $BRIGHTNESS_CURRENT"
	fi
}

brightness_set_decrease(){
	local BRIGHTNESS_SET=$(($BRIGHTNESS_CURRENT-$BRIGHTNESS_DECREASE))
	brightness_apply "$BRIGHTNESS_SET"
}

brightness_set_increase(){
	local BRIGHTNESS_SET=$(($BRIGHTNESS_CURRENT + $BRIGHTNESS_INCREASE))
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

#MUST BE TESTED
brightness_permission(){
	if [[ $UID != 0 ]]; then
		display_message "You must have ROOT previledges for proceduring"
		exit
	else
		chown $AUX2:$AUX2 $BRIGHTNESS_PATH
	fi
}

#############################
#Calling the functions
#############################

#clear

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
	*) echo -e "$MESSAGE_ERROR" ;;
esac
