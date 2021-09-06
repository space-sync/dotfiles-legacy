#!/usr/bin/env sh

#############################
#Declaring the variables
#############################

export LC_ALL=en_US.UTF-8 #Force setting the locale

HOSTS="archlinux.com github.com google.com"
NAME_KERNEL="$(uname -s)"
NETWORK="Offline"

#############################
#Functions
#############################

verify_kernel(){
	case $NAME_KERNEL in
		Darwin) verify_connection_darwin ;;
		Linux) verify_connection_linux ;;
		#Linux) verify_connection_linux_alternative ;;
		#CYGWIN*|MINGW32*|MSYS*|MINGW*) verify_connection_windows ;; #Leaving empty - TODO - Windows incompatability
		*) . ;;
	esac
}

#Must be tested
verify_connection_darwin(){
	#local NAME_WIFI=$()
	#local FILE=(cat /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport)

	if /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | grep -E ' SSID' | cut -d ':' -f 2 | sed 's/ ^*//g' &> /dev/null; then
		echo "$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | grep -E ' SSID' | cut -d ':' -f 2)" | sed 's/ ^*//g'
		echo 'Ethernet if'
		#echo "$NAME_WIFI"
	else
		#echo "$NAME_WIFI"
		echo 'Ethernet else'
	fi
}

verify_connection_linux(){
	local NAME_WIFI=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2 | cut -c 5-)

	if [ -n "$NAME_WIFI" ]; then
		echo "$NAME_WIFI"
	else
		echo 'Offline'
	fi
}

verify_connection_linux_alternative(){
	local SSID=$(iw dev | sed -nr 's/^\t\tssid (.*)/\1/p')

	if [ -n "$SSID" ]; then
		printf '%s' "$SSID"
	else
		echo 'Ethernet'
	fi
}

#Must be implemented
#verify_connection_windows(){}

#############################
#Calling the functions
#############################

for host in $HOSTS; do
	if ping -q -c 1 -W 1 $host &>/dev/null; then
		NETWORK="$(verify_kernel)"
		break
	fi
done

echo "$NETWORK"
