#!/usr/bin/env sh

_spotify(){
    #playerctl -p spotify play-pause
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
}

_vlc(){
    #playerctl -p vlc play-pause
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
}

_spotify_vlc(){
    #playerctl -p spotify play-pause; playerctl -p vlc play-pause
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause; dbus-send --print-reply --dest=org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
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
    echo "ERROR"
fi
