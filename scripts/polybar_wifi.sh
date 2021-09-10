#!/usr/bin/env sh

_wifi_signal(){
    _MAX_SIGNAL=70
    _QUALITY=$(iwconfig wlp2s0 | awk '{print $2}' | grep "Quality" | sed 's/.\{8\}//' | rev | cut -c 4- | rev)

    if [[ $_QUALITY -gt 0 ]] ; then
        _QUALITY_PORCENTAGE=$(($_QUALITY*100/$_MAX_SIGNAL))
    else
        _QUALITY_PORCENTAGE=0
    fi

    if [[ $_QUALITY_PORCENTAGE -le 20 ]] ; then
        _ICON="" #😱
    elif [[ $_QUALITY_PORCENTAGE -le 40 ]] ; then
        _ICON="" #😠
    elif [[ $_QUALITY_PORCENTAGE -le 60 ]] ; then
        _ICON="" #😒
    elif [[ $_QUALITY_PORCENTAGE -le 80 ]] ; then
        _ICON="" #😊
    else
        _ICON="" #😃
    fi

    echo "$_QUALITY_PORCENTAGE % $_ICON   "
}

_wifi_name(){
    #_NAME="$(iwconfig wlp2s0 | awk '{print $4}' | sed 's/.\{7\}//' | rev | cut -c 2- | rev)"
    #_NAME="$(nmcli device wifi | awk '{print $3}' | sed '1d' | sed '2,$d')"
    _NAME="$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2 | cut -c 5-)"

    echo $_NAME
}

_wifi(){
    _CONNECTION_STATUS=$(nmcli general status | awk '{print $1}' | sed '1d')

    if [ "$_CONNECTION_STATUS" = "connected" ]; then
        _SIGNAL=$(_wifi_signal)
        _NAME=$(_wifi_name)
        echo "$_SIGNAL $_NAME"
    elif [ "$_CONNECTION_STATUS" = "connecting" ]; then
        echo "CONNETING"
    else
        echo "NO CONNECTION"
    fi
}

_wifi
