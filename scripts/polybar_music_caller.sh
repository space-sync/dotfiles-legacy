#!/usr/bin/env sh

#_COLOR_SPOTIFY="0F0"
#_COLOR_VLC="f78302"
_COLOR_SPOTIFY="FFFFFF"
_COLOR_VLC="FFFFFF"

_spotify(){
    cmd="org.freedesktop.DBus.Properties.Get"
    domain="org.mpris.MediaPlayer2"
    path="/org/mpris/MediaPlayer2"

    meta=$(dbus-send --print-reply --dest=${domain}.spotify \
    /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:${domain}.Player string:Metadata)

    artist=$(echo "$meta" | sed -nr '/xesam:artist"/,+2s/^ +string "(.*)"$/\1/p' | tail -1  | sed 's/\&/\\&/g' | sed 's#\/#\\/#g')
    album=$(echo "$meta" | sed -nr '/xesam:album"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1| sed 's/\&/\\&/g'| sed 's#\/#\\/#g')
    title=$(echo "$meta" | sed -nr '/xesam:title"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1 | sed 's/\&/\\&/g'| sed 's#\/#\\/#g')

    echo "%{F#$_COLOR_SPOTIFY} ${*:-%artist% - %title%}" | sed "s/%artist%/$artist/g;s/%title%/$title/g;s/%album%/$album/g"i | sed "s/\&/\&/g" | sed "s#\/#\/#g"

    #echo "%{F#$_COLOR_SPOTIFY} ${*:-%title%}" | sed "s/%artist%/$artist/g;s/%title%/$title/g;s/%album%/$album/g"i | sed "s/\&/\&/g" | sed "s#\/#\/#g"
}

_vlc(){
    title=$(qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata | grep "xesam:title:" | cut -c 14-)
    nowplaying=$(qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata | grep "vlc:nowplaying:" | cut -c 16-)
    status=$(qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlaybackStatus)

    #echo $title
    #echo $status
    #Playing
    #Paused
    echo -n "%{F#$_COLOR_VLC} $nowplaying"
}

_spotify_vlc(){
    _S=$(_spotify)
    _V=$(_vlc)
    echo "$_V $_S"
}

process_spotify=$(pgrep -x spotify)
process_vlc=$(pgrep -x vlc)

if [[ ! $process_vlc && ! $process_spotify ]]; then
    #echo "VLC OFF && SPOTIFY OFF"
    echo "-"
elif [[ ! $process_vlc && $process_spotify ]]; then
    #echo "VLC OFF && SPOTIFY ON"
    _spotify
elif [[ $process_vlc && ! $process_spotify ]]; then
    #echo "VLC ON && SPOTIFY OFF"
    _vlc
elif [[ $process_vlc && $process_spotify ]]; then
    #echo "VLC ON && SPOTIFY ON"
    _spotify_vlc
else
    #echo "Spotify: $process_spotify \o/ VLC: $process_vlc"
    echo "Error"
fi

#############################
#Working too
#############################

#if ! pgrep -x vlc >/dev/null; then
#    echo "VLC OFF"
#else
#    #echo "VLC ON"
#    _vlc
#fi

#if ! pgrep -x spotify >/dev/null; then
#    echo "SPOTIFY OFF"
#else
#    #echo "SPOTIFY ON"
#    _spotify
#fi
