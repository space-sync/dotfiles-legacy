#!/usr/bin/env sh

_memory(){
	#Free: Espaço de memória que está completamente sem uso, nem por aplicações, nem pelo kernel, shared, buffers ou cache.
	#Used: É simplesmente o resultado da conta: Used = Total – Free – Buffers – Cache
	
	_SWAP_TOTAL=$(free -m | awk '/Swap:/ { print $2 } /buffers\/cache/ { print $3 }')
	_SWAP_USED=$(free -m | awk '/Swap:/ { print $3 } /buffers\/cache/ { print $3 }')
	_SWAP_FREE=$(free -m | awk '/Swap:/ { print $4 } /buffers\/cache/ { print $3 }')

	_MEMORY_SHARED=$(free -m | awk '/Mem:/ { print $5 } /buffers\/cache/ { print $3 }')
	_MEMORY_BUFFER_CACHE=$(free -m | awk '/Mem:/ { print $6 } /buffers\/cache/ { print $3 }')

	if [[ $_SWAP_USED == 0 ]] || [[ $_SWAP_TOTAL == 0 ]]; then
		_SWAP_PERCENTAGE=0
	else
		_SWAP_PERCENTAGE=$(($_SWAP_USED*100/$_SWAP_TOTAL))
	fi
	
	echo "   Swap: $_SWAP_PERCENTAGE % |    Used: $_SWAP_USED |    Free: $_SWAP_FREE |    Total: $_SWAP_TOTAL"
}

_MEMORY=$(_memory)

# Show on bar
echo "$_MEMORY"
