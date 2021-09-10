#!/usr/bin/env sh

_battery(){
	_BATTERY_PERCENTAGE=$(acpi -b | grep -E -o '[0-9][0-9]?%')
	_BATTERY_REMAINING=$(acpi -b | grep -E -o '[0-9][0-9]:[0-9][0-9]:[0-9][0-9]?')
	_LEVEL=$(cat /sys/class/power_supply/BAT1/capacity)
	_STATUS=$(cat /sys/class/power_supply/BAT1/status)

	if [[ "$_STATUS" == "Charging" ]] ; then
		echo ": $_BATTERY_PERCENTAGE | Charging: $_BATTERY_REMAINING"
	else
		if [[ $_LEVEL -lt 20 ]] ; then
			notify-send --urgency=critical --icon=battery-caution "Low battery ${_LEVEL}%"
		fi
		
		echo ": $_BATTERY_PERCENTAGE | Remaining: $_BATTERY_REMAINING"
	fi
}

_brightness(){
	_GET_BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/brightness)

	#🌕🌔🌓🌒🌑
	echo "🌓 $_GET_BRIGHTNESS%"
}

_memory(){
	#Free: Espaço de memória que está completamente sem uso, nem por aplicações, nem pelo kernel, shared, buffers ou cache.
	#Used: É simplesmente o resultado da conta: Used = Total – Free – Buffers – Cache
	
	_MEMORY_TOTAL=$(free -m | awk '/Mem:/ { print $2 } /buffers\/cache/ { print $3 }')
	_MEMORY_USED=$(free -m | awk '/Mem:/ { print $3 } /buffers\/cache/ { print $3 }')
	#_MEMORY_FREE=$(free -m | awk '/Mem:/ { print $4 } /buffers\/cache/ { print $3 }')
	#_MEMORY_AVALIABLE=$(free -m | awk '/Mem:/ { print $7 } /buffers\/cache/ { print $3 }')
	#MEMORY_SHARED=$(free -m | awk '/Mem:/ { print $5 } /buffers\/cache/ { print $3 }')
	#MEMORY_BUFF_CACHE=$(free -m | awk '/Mem:/ { print $6 } /buffers\/cache/ { print $3 }')

	_MEMORY_FREE=$(($_MEMORY_TOTAL-$_MEMORY_USED))

	#_MEMORY_PERCENTAGE=$(($_MEMORY_FREE*100/$_MEMORY_TOTAL))
	_MEMORY_PERCENTAGE=$(($_MEMORY_USED*100/$_MEMORY_TOTAL))
	
	echo " $_MEMORY_PERCENTAGE % |  Used: $_MEMORY_USED |  Free: $_MEMORY_FREE |  Total: $_MEMORY_TOTAL"
}

_personal(){
	_NAME=$(finger $USER | grep Name | awk -F '\t\tName: ' '{print $2}')
	_SHELL=$(finger $USER | grep Shell | awk -F '\tShell: ' '{print $2}')
	
	echo "$_NAME \t $_SHELL"
}

_time(){	
	#date -d @$(vmstat --stats | awk '/boot time/{print $1}')
	#date '+%s'
	#s/.\{20\}//
	#uptime | awk '{print $3}' | rev | cut -c 2- | rev | cut --delimiter=":" -f 2

	_WEEK=$(date +%w)
	_DAY=$(date +%d/%m/%Y)
	_CLOCK=$(date +%T)

	case $_WEEK in
		0) _DAY_OF_THE_WEEK="Sunday";;
		1*) _DAY_OF_THE_WEEK="Monday";;
		2*) _DAY_OF_THE_WEEK="Tuesday";;
		3*) _DAY_OF_THE_WEEK="Wednesday";;
		4*) _DAY_OF_THE_WEEK="Thuesday";;
		5*) _DAY_OF_THE_WEEK="Friday";;
		6*)_DAY_OF_THE_WEEK="Saturday";;
		*) echo "Something wrong is not quite right here";;
	esac

	echo "$_DAY_OF_THE_WEEK - $_DAY - $_CLOCK"
}

_volume(){
	_VOLUME_PERCENTAGE=$(amixer -D pulse sget Master | grep 'Left:' | awk -F'[][]' '{ print $2 }')
	
	#🔊🎧🔈🔇🔉
	echo "🔊 $_VOLUME_PERCENTAGE"
}

_weather(){
	#_TEMPERATURE=$(curl -Ss 'https://wttr.in?0&T&Q' | cut -c 16- | head -2 | xargs echo)
	_TEMPERATURE=$(curl -Ss 'https://wttr.in?0&T&Q' | cut -c 16- | head -2 | sed '1d')
	
	#_IP_ADDRESS=$(curl -s https://ipinfo.io/ip)

	#_PLACE=$(curl -s https://ipvigilante.com/$_IP_ADDRESS | jq '.data.latitude, .data.longitude, .data.city_name, .data.country_name')
	#_PLACE=$(curl -s https://ipvigilante.com/$_IP_ADDRESS | jq '.data.city_name' | cut -c 1-)
	
	echo "$_TEMPERATURE"
	#echo "\t $_TEMPERATURE $_PLACE"
}

while :
do
	_MINUTES=$(date +%M)
	#_SYSYEM_BOOT_TIME=$(uptime | awk '{print $3}' | rev | cut -c 2- | rev | cut --delimiter=":" -f 2)
	
	_BATTERY=$(_battery)
	_BRIGHTNESS=$(_brightness)
	_MEMORY=$(_memory)
	_PERSONAL=$(_personal)
	_TIME=$(_time)
	_VOLUME=$(_volume)

	#_MINUTES_MOD=$(($_MINUTES%10))

	#if [ "$_MINUTES_MOD" = "0" ]; then
	#if [ $_MINUTES_MOD = 0 ]; then
	#	_WEATHER=$(_weather)
    #fi

	#if [ "$_MINUTES" = "00" ] || [ "$_MINUTES" = "15" ] || [ "$_MINUTES" = "30" ] || [ "$_MINUTES" = "45" ]; then
	#	_WEATHER=$(_weather)
    #fi
	
	# Show on bar
	echo "$_PERSONAL \t $_MEMORY \t $_VOLUME \t $_BRIGHTNESS \t $_BATTERY \t $_WEATHER $_TIME \t"

	sleep 0.5
done
