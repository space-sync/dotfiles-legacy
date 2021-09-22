#!/usr/bin/env sh

#############################
#Declaring variables
#############################

AUX1=$1

MESSAGE_HELP="
\t\t\t\tPower off menu
\t\t\t\t--------------\n
[Description]
This is a graphical user interface (GUI) menu for powering off the operating system

[Dependencies]
Must have Yad installed on your operating system.

[Parameters]
-h\t--help\t-?\t\tDisplay this help message
-e\t--edit\t\t\tEdit this script file
--menu\t--power-menu\t\tDisplay the graphical user interface (GUI) menu
--show\t--power-show\t\tDisplay a command line interface (CLI) message
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_HELP"

#############################
#Functions
#############################

power_off_show(){
	#echo "Power"
	echo " "
}

power_off_menu(){
	#_LOCK="i3lock -n --color '#0a81f5'"
	_LOCK="$HOME/.dotfiles/scripts/system_matrix_lock.sh"

	action=$(yad \
		--title "Poweroff manager" \
		--height 100 \
		--width 500 \
		--entry \
		--button="OK" \
		--button="Close" \
		--text="Select" \
		--entry-text \
			"None" \
			"Restart Graphical Interface" \
			"Rebuild dotfiles" \
			"Lock" \
			"Suspend" \
			"Hibernate" \
			"Reboot" \
			"Shutdown" \
			"Shutdown with a time" \
	)

	case "$action" in
		"None") echo "There is no selected option" ;;
		"Restart Graphical Interface") i3 restart ;;
		"Rebuild dotfiles") $HOME/.dotfiles/testing.sh -x ;;
		"Lock") $_LOCK ;;
		"Suspend") systemctl suspend && $_LOCK ;;
		"Hibernate") systemctl hibernate && $_LOCK ;;
		"Logout") i3-msg exit ;;
		"Reboot") systemctl reboot ;;
		"Shutdown") systemctl poweroff ;;
		"Shutdown with a time")
			minutes=$(yad \
				--text="Type how many minutes you want to shutdown the operating system" \
				--entry \
				--button="OK" \
				--button="Close" \
			)

			shutdown -h +$minutes & $(yad \
				--text="operating system is going to be shutted down in $minutes minutes.\nAre you sure about it?" \
				--button="OK" \
				--button="Close" \
			) && echo $?

			if [ $? -ne 0 ]; then
				yad --text="Operation canceled and operating system can still breath!"
				notify-send "Operation canceled and operating system can still breath!" &
				shutdown -c
				exit
			fi

			if [ $? -ne 1 ]; then
				yad --text="operating system is up $minutes minutes to be shutted down!"
				notify-send "operating system is up $minutes minutes to be shutted down!" &
				shutdown -h +minutes
				exit
			fi
		;;
		*) : ;;
	esac
}

#############################
#Calling the functions
#############################

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;;
	"--menu" | "--power-menu") power_off_menu ;;
	"--show" | "--power-show") power_off_show ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
