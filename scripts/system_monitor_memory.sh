#!/usr/bin/env sh

#############################
#Notes
#Free: Espaço de memória que está completamente sem uso, nem por aplicações, nem pelo kernel, shared, buffers ou cache.
#Used: É simplesmente o resultado da conta: Used = Total – Free – Buffers – Cache
#############################

#############################
#Declaring variables
#############################

AUX1=$1

MESSAGE_HELP="
\t\t\tMemory monitor
\t\t\t--------------\n
-h\t--help\t-?\t\t\tDisplay this message error
-e\t--edit\t\t\t\tEdit this script file
--ram\t--memory-ram\t\t\tMonitor the RAM memory values
--swap\t--memory-swap\t\t\tMonitor the SWAP memory values
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_HELP"

#############################
#Functions
#############################

memory_ram(){
	local MEMORY_RAM_TOTAL=$(free -m | awk '/Mem:/ { print $2 } /buffers\/cache/ { print $3 }')
	local MEMORY_RAM_USED=$(free -m | awk '/Mem:/ { print $3 } /buffers\/cache/ { print $3 }')
	local MEMORY_RAM_FREE=$(($MEMORY_RAM_TOTAL-$MEMORY_RAM_USED))
	local MEMORY_RAM_PERCENTAGE=$(($MEMORY_RAM_USED*100/$MEMORY_RAM_TOTAL))
	#local MEMORY_RAM_PERCENTAGE=$(($_MEMORY_FREE*100/$_MEMORY_TOTAL))
	#local MEMORY_RAM_AVALIABLE=$(free -m | awk '/Mem:/ { print $7 } /buffers\/cache/ { print $3 }')

	echo "Memory    $MEMORY_RAM_PERCENTAGE % |    Used: $MEMORY_RAM_USED |    Free: $MEMORY_RAM_FREE |    Total: $MEMORY_RAM_TOTAL"
}

memory_swap(){
	local MEMORY_SWAP_TOTAL=$(free -m | awk '/Swap:/ { print $2 } /buffers\/cache/ { print $3 }')
	local MEMORY_SWAP_USED=$(free -m | awk '/Swap:/ { print $3 } /buffers\/cache/ { print $3 }')
	local MEMORY_SWAP_FREE=$(free -m | awk '/Swap:/ { print $4 } /buffers\/cache/ { print $3 }')

	local MEMORY_SWAP_SHARED=$(free -m | awk '/Mem:/ { print $5 } /buffers\/cache/ { print $3 }')
	local MEMORY_SWAP_BUFFER_CACHE=$(free -m | awk '/Mem:/ { print $6 } /buffers\/cache/ { print $3 }')

	#Calcutate the Swap when it is and when it is not being used
	if [[ $MEMORY_SWAP_USED == 0 ]] || [[ $MEMORY_SWAP_TOTAL == 0 ]]; then
		local MEMORY_SWAP_PERCENTAGE=0
	else
		local MEMORY_SWAP_PERCENTAGE=$(($MEMORY_SWAP_USED*100/$MEMORY_SWAP_TOTAL))
	fi
	
	echo "   Swap: $MEMORY_SWAP_PERCENTAGE % |    Used: $MEMORY_SWAP_USED |    Free: $MEMORY_SWAP_FREE |    Total: $MEMORY_SWAP_TOTAL"
}

#############################
#Calling the functions
#############################

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;;
	"--ram" | "--memory-ram") memory_ram ;;
	"--swap" | "--memory-swap") memory_swap ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
