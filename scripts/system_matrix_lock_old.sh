#!/bin/bash

#Choosing the terminal
#gnome-terminal -e cmatrix &
urxvt -e cmatrix &

#Setting the delay
sleep 0.2

#Setting the terminal to fullscreen mode
i3-msg fullscreen toggle

#Locking the operating system
#i3lock -n --color "#ff009f"; i3-msg kill
i3lock -n; i3-msg kill

#Sending a mensage right after the operating system gets unlocked
_NAME=$(finger $USER | grep Name | awk -F '\t\tName: ' '{print $2}')
notify-send "Welcome back, $_NAME" &