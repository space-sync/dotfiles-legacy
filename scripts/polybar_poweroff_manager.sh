#!/usr/bin/env sh

#--entry --image=/usr/share/???.png

#_LOCK="i3lock -n --color '#0a81f5'"
_LOCK="/home/joker/.dotfiles/scripts/system_matrix_lock.sh"

action=$(yad \
--title "Poweroff manager" \
--height 100 \
--width 500 \
--entry \
--button="OK" \
--button="Close" \
--text="Select" \
--entry-text \
"None" "Restart Graphical Interface" "Rebuild dotfiles" "Lock" "Suspend" "Hibernate" "Reboot" "Shutdown" "Shutdown with a time" \
)

case "$action" in
    "None") echo "There is no selected option";;
    "Restart Graphical Interface") i3 restart;;
    "Rebuild dotfiles") /usr/share/lord/scripts/manager_dotfiles.sh;;
    "Lock") $_LOCK;;
    "Suspend") systemctl suspend && $_LOCK;;
    "Hibernate") systemctl hibernate && $_LOCK;;
    "Logout") i3-msg exit;;
    "Reboot") systemctl reboot;;
    "Shutdown") systemctl poweroff;;
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
