#!/usr/bin/env sh

_spotify(){
    cmd="org.freedesktop.DBus.Properties.Get"
    domain="org.mpris.MediaPlayer2"
    path="/org/mpris/MediaPlayer2"

    meta=$(dbus-send --print-reply --dest=${domain}.spotify \
    /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:${domain}.Player string:Metadata)

    #dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata

    artist=$(echo "$meta" | sed -nr '/xesam:artist"/,+2s/^ +string "(.*)"$/\1/p' | tail -1  | sed 's/\&/\\&/g' | sed 's#\/#\\/#g')
    album=$(echo "$meta" | sed -nr '/xesam:album"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1| sed 's/\&/\\&/g'| sed 's#\/#\\/#g')
    title=$(echo "$meta" | sed -nr '/xesam:title"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1 | sed 's/\&/\\&/g'| sed 's#\/#\\/#g')

    echo " ${*:-%artist% - %title%}" | sed "s/%artist%/$artist/g;s/%title%/$title/g;s/%album%/$album/g"i | sed "s/\&/\&/g" | sed "s#\/#\/#g"

    #echo " ${*:-%album% - %artist% - %title%}" | sed "s/%artist%/$artist/g;s/%title%/$title/g;s/%album%/$album/g"i | sed "s/\&/\&/g" | sed "s#\/#\/#g"

    #echo " ${*:-%title%}" | sed "s/%artist%/$artist/g;s/%title%/$title/g;s/%album%/$album/g"i | sed "s/\&/\&/g" | sed "s#\/#\/#g"
}

_vlc(){
    title=$(qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata | grep "xesam:title:" | cut -c 14-)
    nowplaying=$(qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata | grep "vlc:nowplaying:" | cut -c 16-)
    genre=$(qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Metadata | grep "xesam:genre:" | cut -c 13-)
    status=$(qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlaybackStatus)

    #xesam:genre: Rock

	#echo $title
    #echo $status
    #Playing
    #Paused
    echo -n " $genre - $nowplaying"
}

_spotify_vlc(){
    _S=$(_spotify)
    _V=$(_vlc)
    echo "$_V \t\t $_S"
}

while :
do
	process_spotify=$(pgrep -x spotify)
	process_vlc=$(pgrep -x vlc)

	if [[ ! $process_vlc && ! $process_spotify ]]; then
		_OUTPUT="Spotify and VLC are not running"
	elif [[ ! $process_vlc && $process_spotify ]]; then
		_OUTPUT=$(_spotify)
	elif [[ $process_vlc && ! $process_spotify ]]; then
		_OUTPUT=$(_vlc)
	elif [[ $process_vlc && $process_spotify ]]; then
		_OUTPUT=$(_spotify_vlc)
	else
		_OUTPUT="ERROR"
	fi
	
	# Show on bar
	#echo -e "$_OUTPUT \t \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t"

	center() {
		termwidth="$(tput cols)"
		#padding="$(printf '%0.1s' ={1..83})"
		#padding="$(printf '%0.1s' ={1..82})"
		#padding="$(printf '%0.2s' ^v{1..50})"
		padding="$(printf '%0.2s' .{1..55})"

		printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
	}

	#center "Something I want to print"
	center " $_OUTPUT "

	sleep 0.5
done
