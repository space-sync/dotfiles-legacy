#!/usr/bin/env sh

#############################
#Declaring variables
#############################

AUX1=$1

TERMINAL_COLOR_X11VNC_ENABLE="0A81F5"
TERMINAL_COLOR_X11VNC_DISABLE="FFFFFF"
TERMINAL_ICON=""

PROCESS_X11=$(pgrep -x x11vnc)

MESSAGE_HELP="
\t\t\t\tSystem localhost
\t\t\t\t----------------\n
[Description]

[Dependencies]
X11

[Parameters]
-h\t\t--help\t-?\t\t\tDisplay this message help
-e\t\t--edit\t\t\t\tEdit this script file
--ip\t\t--network-localhost-get-ip\tGet the localhost ip from this machine
--vnc-on\t--network-vnc-enable\t\tEnable X11VNC remote access
--vnc-off\t--network-vnc-disable\t\tDisable X11VNC remote access
-nwd\t\t--network-wifi-display\t\t???
-nwn\t\t--network-wifi-name\t\t???
-nws\t\t--network-wifi-signal\t\t???
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_HELP"

#############################
#Functions
#############################

network_localhost_get_ip(){
    local LOCALHOST_INTERFACE=$(route | awk '/^default/{print $NF}')
    local LOCALHOST_IP=$(ip addr show "$LOCALHOST_INTERFACE" | grep -w "inet" | awk '{ print $2; }' | sed 's/\/.*$//')

    #Check if X11VNC process is running
    if [[ $PROCESS_X11 ]]; then
        local TERMINAL_COLOR=$TERMINAL_COLOR_X11VNC_ENABLE
    else
        local TERMINAL_COLOR=$TERMINAL_COLOR_X11VNC_DISABLE
    fi

    echo -e "%{F#$TERMINAL_COLOR}${TERMINAL_ICON}    $LOCALHOST_IP"
}

network_share_vnc_enable(){
    x11vnc --forever
}

network_share_vnc_disable(){
    killall -9 x11vnc
}

#############################
#Fixing
#############################

network_wifi_display(){
    local WIFI_CONNECTION_STATUS=$(nmcli general status | awk '{print $1}' | sed '1d')

    if [ "$WIFI_CONNECTION_STATUS" == "connected" ]; then
        local WIFI_SIGNAL=$(network_wifi_signal)
        local WIFI_NAME=$(network_wifi_name)
        echo "$WIFI_SIGNAL $WIFI_NAME"
    elif [ "$WIFI_CONNECTION_STATUS" == "connecting" ]; then
        echo "CONNETING"
    else
        echo "NO CONNECTION"
    fi
}

network_wifi_name(){
    #local WIFI_NAME="$(iwconfig wlp2s0 | awk '{print $4}' | sed 's/.\{7\}//' | rev | cut -c 2- | rev)"
    #local WIFI_NAME="$(nmcli device wifi | awk '{print $3}' | sed '1d' | sed '2,$d')"
    local WIFI_NAME="$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2 | cut -c 5-)"

    #Return
    echo $WIFI_NAME
}

network_wifi_signal(){
    local WIFI_MAX_SIGNAL=70
    local WIFI_QUALITY=$(iwconfig wlp2s0 | awk '{print $2}' | grep "Quality" | sed 's/.\{8\}//' | rev | cut -c 4- | rev)

    if [[ $WIFI_QUALITY -gt 0 ]] ; then
        local WIFI_QUALITY_PORCENTAGE=$(($WIFI_QUALITY*100/$WIFI_MAX_SIGNAL))
    else
        local WIFI_QUALITY_PORCENTAGE=0
    fi

    if [[ $WIFI_QUALITY_PORCENTAGE -le 20 ]] ; then
        local WIFI_ICON="" #😱
    elif [[ $WIFI_QUALITY_PORCENTAGE -le 40 ]] ; then
        local WIFI_ICON="" #😠
    elif [[ $WIFI_QUALITY_PORCENTAGE -le 60 ]] ; then
        local WIFI_ICON="" #😒
    elif [[ $WIFI_QUALITY_PORCENTAGE -le 80 ]] ; then
        local WIFI_ICON="" #😊
    else
        local WIFI_ICON="" #😃
    fi

    #Return
    echo "$WIFI_QUALITY_PORCENTAGE % $WIFI_ICON   "
}

#############################
#Dedicated functions for Polybar
#############################

polybar_display(){
    if [[ $PROCESS_X11 ]]; then
        network_localhost_get_ip
    else
        network_wifi_display
    fi
}

polybar_click_left(){
    alacritty -e nmtui &
    #gnome-control-center wifi &
    #gnome-control-center &
}

polybar_click_middle(){
    :
}

polybar_click_right(){
    if [[ $PROCESS_X11 ]]; then
        network_share_vnc_disable
    else
        network_share_vnc_enable
    fi
}

polybar_double_click_left(){
    :
}
    
polybar_double_click_middle(){
    :
}
    
polybar_double_click_right(){
    :
}

#############################
#Calling the functions
#############################

case $AUX1 in
    "") echo -e "Lalala" ;;
    "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
    "-e" | "--edit") $EDITOR $0 ;;
    "--ip" | "--network-localhost-get-ip") network_localhost_get_ip ;;
    "--vnc-on" | "--network-vnc-enable") network_share_vnc_enable ;;
    "--vnc-off" | "--network-vnc-disable") network_share_vnc_disable ;;
    "-nwd" | "--network-wifi-display") network_wifi_display ;;
    "-nwn" | "--network-wifi-name") network_wifi_name ;;
    "-nws" | "--network-wifi-signal") network_wifi_signal ;;
    #Calling the dedicate Polybar functions
    "--polybar-display") polybar_display ;;
    "--polybar-click-left") polybar_click_left ;;
    "--polybar-click-middle") polybar_click_middle ;;
    "--polybar-click-right") polybar_click_right ;;
    "--polybar-double-click-left") polybar_double_click_left ;;
    "--polybar-double-click-middle") polybar_double_click_middle ;;
    "--polybar-double-click-right") polybar_double_click_right ;;
    *) echo -e "$MESSAGE_ERROR" ;;
esac