#!/usr/bin/env zsh

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
	
	echo "Memory  $_MEMORY_PERCENTAGE % |  Used: $_MEMORY_USED |  Free: $_MEMORY_FREE |  Total: $_MEMORY_TOTAL"
}

_MEMORY=$(_memory)

# Show on bar
echo "$_MEMORY"