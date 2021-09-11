#!/usr/bin/env sh

#_COLOR_SPOTIFY="0F0"
#_COLOR_VLC="f78302"
_COLOR_SPOTIFY="FFFFFF"
_COLOR_VLC="FFFFFF"

DBUS_CMD="org.freedesktop.DBus.Properties.Get"
DBUS_DOMAIN="org.mpris.MediaPlayer2"
DBUS_PATH="/org/mpris/MediaPlayer2"

_spotify(){
    path="/org/mpris/MediaPlayer2"
	local DBUS_PLAYER="spotify"

    local DBUS_META=$(dbus-send --print-reply \
		--dest=${DBUS_DOMAIN}.${DBUS_PLAYER} \
		${DBUS_PATH} \
		${DBUS_CMD} \
		string:${DBUS_DOMAIN}.Player \
		string:Metadata)

    artist=$(echo "$DBUS_META" | sed -nr '/xesam:artist"/,+2s/^ +string "(.*)"$/\1/p' | tail -1  | sed 's/\&/\\&/g' | sed 's#\/#\\/#g')
    album=$(echo "$DBUS_META" | sed -nr '/xesam:album"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1| sed 's/\&/\\&/g'| sed 's#\/#\\/#g')
    title=$(echo "$DBUS_META" | sed -nr '/xesam:title"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1 | sed 's/\&/\\&/g'| sed 's#\/#\\/#g')

    echo "%{F#$_COLOR_SPOTIFY} ${*:-%artist% - %title%}" | sed "s/%artist%/$artist/g;s/%title%/$title/g;s/%album%/$album/g"i | sed "s/\&/\&/g" | sed "s#\/#\/#g"

    #echo "%{F#$_COLOR_SPOTIFY} ${*:-%title%}" | sed "s/%artist%/$artist/g;s/%title%/$title/g;s/%album%/$album/g"i | sed "s/\&/\&/g" | sed "s#\/#\/#g"
}

_vlc(){
	local DBUS_PLAYER="vlc"

	local DBUS_META=$(dbus-send --print-reply \
		--dest=${DBUS_DOMAIN}.${DBUS_PLAYER} \
		${DBUS_PATH} \
		${DBUS_CMD} \
		string:${DBUS_DOMAIN}.Player \
		string:'Metadata')

    local SONG_TITLE_TMP=$(echo "$DBUS_META" \
		| sed -nr '/xesam:title"/,+2s/^ +variant +string "(.*)"$/\1/p' \
		| tail -1 \
		| sed 's/\&/\\&/g'\
		| sed 's#\/#\\/#g')

	local SONG_PLAYING_NOW_TMP=$(echo "$DBUS_META" \
		| sed -nr '/nowplaying"/,+2s/^ +variant +string "(.*)"$/\1/p' \
		| tail -1 \
		| sed 's/\&/\\&/g'\
		| sed 's#\/#\\/#g')

	SONG_TITLE=$(echo "$SONG_TITLE_TMP" | xargs)
	SONG_PLAYING_NOW=$(echo "$SONG_PLAYING_NOW_TMP" | xargs)

    echo -n "%{F#$_COLOR_VLC}   $SONG_TITLE - $SONG_PLAYING_NOW"
}

#dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'
_vlc_worked(){
	DBUS_CMD="org.freedesktop.DBus.Properties.Get"
	DBUS_DOMAIN="org.mpris.MediaPlayer2"
	DBUS_PATH="/org/mpris/MediaPlayer2"

	SONG_TITLE_TMP=$(dbus-send --print-reply --session \
		--dest=org.mpris.MediaPlayer2.vlc \
		/org/mpris/MediaPlayer2 \
		org.freedesktop.DBus.Properties.Get \
		string:'org.mpris.MediaPlayer2.Player' \
		string:'Metadata' \
			| awk '/"xesam:title"/{getline; print}' \
			| sed -n 's/variant//p' \
			| sed -n 's/string//p')

	SONG_PLAYING_NOW_TMP=$(dbus-send --print-reply --session \
		--dest=org.mpris.MediaPlayer2.vlc \
		/org/mpris/MediaPlayer2 \
		org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' \
		string:'Metadata' \
			| awk '/"vlc:nowplaying"/{getline; print}' \
			| sed -n 's/variant//p' \
			| sed -n 's/string//p')

	#Album
	#Artist
	#Status

    #status=$(qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlaybackStatus)
    #echo $status

    #Playing
    #Paused

	SONG_TITLE=$(echo "$SONG_TITLE_TMP" | xargs)
	SONG_PLAYING_NOW=$(echo "$SONG_PLAYING_NOW_TMP" | xargs)

    echo -n "%{F#$_COLOR_VLC}   $SONG_TITLE - $SONG_PLAYING_NOW"
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
