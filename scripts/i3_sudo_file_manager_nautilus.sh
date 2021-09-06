#!/bin/sh

# Make sure only root can run script
if [ "$(id -u)" != "0" ]; then
#   echo "This script must be run as root" 1>&2
   notify-send "This script must be run as root" 1>&2
   exit 1
fi

_nautilus(){
    echo "Opening Nautilus as Root"
    sudo nautilus
}

_pcmanfm(){
    echo "Opening PCMANFM as Root"
    sudo pcmanfm
}

_nautilus
#_pcmanfm