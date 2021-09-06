#!/usr/bin/env zsh

_WEEK=$(date +%w)
_DAY=$(date +%d/%m/%Y)
_CLOCK=$(date +%T)

_MODE="full"
#_MODE="short"

case $_WEEK in
    0) _DAY_OF_THE_WEEK="Sun";;
    1*) _DAY_OF_THE_WEEK="Mon";;
    2*) _DAY_OF_THE_WEEK="Tue";;
    3*) _DAY_OF_THE_WEEK="Wed";;
    4*) _DAY_OF_THE_WEEK="Thu";;
    5*) _DAY_OF_THE_WEEK="Fri";;
    6*) _DAY_OF_THE_WEEK="Sat";;
    *) echo Something wrong is not quite right here;;
esac

if [[ $_MODE == "full" ]]; then
    _TIME="$_DAY_OF_THE_WEEK $_CLOCK $_DAY"
elif [[ $_MODE == "short" ]]; then
    _TIME="$_CLOCK"
else
    _TIME="Error"
fi

# Show on bar
echo "$_TIME"