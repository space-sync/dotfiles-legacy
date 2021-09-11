#!/usr/bin/env sh

#############################
#Declaring the variables
#############################

AUX1=$1

#Absolute path where this file script is storaged
#ROFI_THEME_PATH="$(dirname "$(readlink -f "$0")")"
ROFI_THEME_PATH="$HOME/.dotfiles/src/rofi"

MESSAGE_HELP="
\t\t\tRofi launcher theme
\t\t\t-------------------\n
-h\t--help\t-?\t\t\tDisplay this help message
-e\t--edit\t\t\t\tEdit this script file
-l\t--list\t\t\t\tList all availabel themes
-rtl\t--rofi-theme-launchpad\t\tApply Rofi launchpad theme
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_HELP"

#############################
#Functions
#############################

display_message(){
	echo -e "#############################\n#$1...\n#############################"
}

rofi_theme_apply(){
	rofi -no-lazy-grab -show drun -modi drun -theme $ROFI_THEME_PATH/$1
}

rofi_theme_list(){
	display_message "Themes storaged in $ROFI_THEME_PATH/ directory"

	for FILENAME in	$ROFI_THEME_PATH/*; do
		echo -e "$FILENAME"
	done
}

rofi_theme_launchpad(){
	rofi_theme_apply "launchpad"
}

#############################
#Calling the functions
#############################

clear

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;;
	#"-" | "--") 
	"-l" | "--list") rofi_theme_list ;;
	"-rtl" | "--rofi-theme-launchpad") rofi_theme_launchpad ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
