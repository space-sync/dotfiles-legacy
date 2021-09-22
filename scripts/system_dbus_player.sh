#!/usr/bin/env sh

#############################
#Declaring variables
#############################

AUX1=$1

TERMINAL_COLOR_GENERIC="FFFFFF"
TERMINAL_COLOR_SPOTIFY="0F0"
TERMINAL_COLOR_VLC="f78302"

TERMINAL_ICON_GENERIC=""
TERMINAL_ICON_SPOTIFY=""
TERMINAL_ICON_VLC=""

DBUS_VOLUME_DIFF="0.1"
DBUS_DOMAIN="org.mpris.MediaPlayer2"
DBUS_PATH="/org/mpris/MediaPlayer2"
DBUS_PLAYER="vlc"
#DBUS_PLAYER="spotify"

MESSAGE_HELP="
\t\t\tMusic player terminal controller
\t\t\t--------------------------------\n
[Description]
Control the music player using the DBus command line interface (CLI)

[Dependencies]
Must have DBus, Zscroll, MPRIS2, PlayerCTL, Lyrics-in-Terminal and a music player such as Spotify and VLC

[Parameters]
-h\t\t--help\t-?\t\t\t\tDisplay this help message
-e\t\t--edit\t\t\t\t\tEdit this script file
--info\t\t--system-dbus-info\t\t\tDisplay all the song metadata
--show\t\t--system-dbus-display\t\t\tGet the current song artist and title
--prev\t\t--system-dbus-previous\t\t\tGo back to the previous song played
--play\t\t--system-dbus-play-pause\t\tPlay/Pause buttom toogle
--next\t\t--system-dbus-next\t\t\tGo to the next next song
#--get\t\t--system-dbus-current-player\t\tGet the current media player name whose is running
--s-b\t\t--system-dbus-skip-backward\t\tGo back ??? seconds in the current song
--s-f\t\t--system-dbus-skip-forward\t\tSkip ??? seconds forward in the current song
--vol\t\t--system-dbus-volume-current\t\tGet the current volume from the music player
--down\t\t--system-dbus-volume-decrease\t\tDecrease the current song volume
--normal\t--system-dbus-volume-normal\t\tSet the 1.0 to volume to restore to the default value
--up\t\t--system-dbus-volume-increase\t\tIncrease the current song volume
#--lyrics\t--system-dbus-lyrics\t\t\tDisplay the current song lyrics
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_HELP"

#############################
#Functions
#############################

display_message(){
    echo -e "$1"
    #echo -e "$1"  | zscroll -b "⮕ "
	#echo "lalala" | zscroll -b "⮕ "
}

system_process_check(){
    PROCESS_RUNNING=$(pgrep -x $1)

    #Check if the process is running
	if [[ ! $PROCESS_RUNNING ]]; then
		display_message "-"
		exit
	fi
}

display_message_debug(){
	echo -e "
	#############################
	#DBus domain:\t\t$DBUS_DOMAIN
	#DBus path:\t\t$DBUS_PATH
	#DBus command:\t\t$@
	#DBus player:\t\t$DBUS_PLAYER
	#############################
	"
}

system_dbus_send_command(){
	local DBUS_CMD=$@

	#display_message_debug $DBUS_CMD

	system_process_check $DBUS_PLAYER

    dbus-send --print-reply \
		--dest=${DBUS_DOMAIN}.${DBUS_PLAYER} \
		${DBUS_PATH} \
		${DBUS_CMD}
}

#MUST BE FIXED - NOT WORKING
system_dbus_current_player(){
	#/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlaybackStatus' == 'Playing'
	#DBUS_PATH="/org/mpris/MediaPlayer2"
	#DBUS_DOMAIN="org.mpris.MediaPlayer2"

	local DBUS_CMD=$1
	system_process_check $DBUS_PLAYER

	display_message_debug $DBUS_CMD $DBUS_PLAYER

    #dbus-send --print-reply \
	#	--dest=${DBUS_DOMAIN}.${DBUS_PLAYER} \
	#	${DBUS_PATH} \
	#	${DBUS_CMD}

    dbus-send --print-reply \
		${DBUS_PATH} \
		org.mpris.MediaPlayer2.Player.Player
		#org.mpris.MediaPlayer2.Player.PlaybackStatus
		#${DBUS_CMD}
}

system_dbus_info(){
	local DBUS_CMD="org.freedesktop.DBus.Properties.Get string:${DBUS_DOMAIN}.Player string:Metadata"
	local DBUS_META=$(system_dbus_send_command $DBUS_CMD)

	#Return
	echo "$DBUS_META"
}

system_dbus_display(){
	local DBUS_META=$(system_dbus_info)

	system_process_check $DBUS_PLAYER

    local SONG_ALBUM_TMP=$( \
		echo "$DBUS_META" \
		| sed -nr '/xesam:album"/,+2s/^ +variant +string "(.*)"$/\1/p' \
		| tail -1 \
		| sed 's/\&/\\&/g' \
		| sed 's#\/#\\/#g')

    local SONG_ARTIST_TMP=$( \
		echo "$DBUS_META" \
		| sed -nr '/xesam:artist"/,+2s/^ +string "(.*)"$/\1/p' \
		| tail -1 \
		| sed 's/\&/\\&/g' \
		| sed 's#\/#\\/#g')

    local SONG_TITLE_TMP=$( \
		echo "$DBUS_META" \
		| sed -nr '/xesam:title"/,+2s/^ +variant +string "(.*)"$/\1/p' \
		| tail -1 \
		| sed 's/\&/\\&/g'\
		| sed 's#\/#\\/#g')

	local SONG_PLAYING_NOW_TMP=$( \
		echo "$DBUS_META" \
		| sed -nr '/nowplaying"/,+2s/^ +variant +string "(.*)"$/\1/p' \
		| tail -1 \
		| sed 's/\&/\\&/g'\
		| sed 's#\/#\\/#g')

	#Fixing empty spaces from the string variables
	local SONG_ALBUM=$(echo "$SONG_ALBUM_TMP" | xargs)
	local SONG_ARTIST=$(echo "$SONG_ARTIST_TMP" | xargs)
	local SONG_TITLE=$(echo "$SONG_TITLE_TMP" | xargs)
	local SONG_PLAYING_NOW=$(echo "$SONG_PLAYING_NOW_TMP" | xargs)

	#Apply the right variables according to the music player
	case $1 in
		"spotify")
			local TERMINAL_COLOR=$TERMINAL_COLOR_SPOTIFY
			local TERMINAL_ICON=$TERMINAL_ICON_SPOTIFY
			;;
		"vlc")
			local TERMINAL_COLOR=$TERMINAL_COLOR_VLC
    		local TERMINAL_ICON=$TERMINAL_ICON_VLC
			;;
		*)
			local TERMINAL_COLOR=$TERMINAL_COLOR_GENERIC
			local TERMINAL_ICON=$TERMINAL_ICON_GENERIC
			;;
	esac

	#display_message "%{F#$TERMINAL_COLOR}${TERMINAL_ICON}   $SONG_TITLE | $SONG_PLAYING_NOW"
	#display_message "%{F#$TERMINAL_COLOR}${TERMINAL_ICON}    $SONG_ARTIST | $SONG_TITLE $SONG_PLAYING_NOW"
	display_message "%{F#$TERMINAL_COLOR}${TERMINAL_ICON}    $SONG_ARTIST | $SONG_TITLE $SONG_PLAYING_NOW"

	#display_message "%{F#$TERMINAL_COLOR}${TERMINAL_ICON} ${*:-%artist% - %title%}" | sed "s/%artist%/$artist/g;s/%title%/$title/g;s/%album%/$album/g"i | sed "s/\&/\&/g" | sed "s#\/#\/#g"
}

system_dbus_previous(){
	local DBUS_CMD="org.mpris.MediaPlayer2.Player.Previous"
	system_dbus_send_command $DBUS_CMD
}

system_dbus_play_pause(){
	local DBUS_CMD="org.mpris.MediaPlayer2.Player.PlayPause"
	system_dbus_send_command $DBUS_CMD
}

system_dbus_next(){
	local DBUS_CMD="org.mpris.MediaPlayer2.Player.Next"
	system_dbus_send_command $DBUS_CMD
}

system_dbus_skip_backward(){
	local DBUS_CMD="org.mpris.MediaPlayer2.Player.Seek int64:-2000000"
	system_dbus_send_command $DBUS_CMD
}

system_dbus_skip_forward(){
	local DBUS_CMD="org.mpris.MediaPlayer2.Player.Seek int64:2000000"
	system_dbus_send_command $DBUS_CMD
}

system_dbus_volume_current(){
	local DBUS_CMD="org.freedesktop.DBus.Properties.Get string:${DBUS_DOMAIN}.Player string:Volume"
	local DBUS_META=$(system_dbus_send_command $DBUS_CMD)

	#Extract the value from:
	#method return time=1632021102.487198 sender=:1.14763 -> destination=:1.19271 serial=4581 reply_serial=2
	#variant       double 1
	local DBUS_VOLUME_VALUE_CURRENT=$( \
		echo "$DBUS_META" \
		| sed -n '2 p' \
		| awk '{print $3}')

	#Return
	echo "$DBUS_VOLUME_VALUE_CURRENT"
}

system_dbus_volume_decrease(){
	local DBUS_VOLUME_VALUE_CURRENT=$(system_dbus_volume_current)
	local DBUS_VOLUME_VALUE_NEWEST=$(bc<<<"$DBUS_VOLUME_VALUE_CURRENT - $DBUS_VOLUME_DIFF")

	#Apply the new volume value
	local DBUS_CMD="org.freedesktop.DBus.Properties.Set string:${DBUS_DOMAIN}.Player string:Volume variant:double:$DBUS_VOLUME_VALUE_NEWEST"
	system_dbus_send_command $DBUS_CMD

	#Debugging values
	#echo "$DBUS_VOLUME_VALUE_CURRENT"
	#echo "$DBUS_VOLUME_VALUE_NEWEST"
}

system_dbus_volume_normal(){
	local DBUS_VOLUME_VALUE_CURRENT=$(system_dbus_volume_current)
	local DBUS_VOLUME_VALUE_NEWEST="1.0"

	#Apply the new volume value
	local DBUS_CMD="org.freedesktop.DBus.Properties.Set string:${DBUS_DOMAIN}.Player string:Volume variant:double:$DBUS_VOLUME_VALUE_NEWEST"
	system_dbus_send_command $DBUS_CMD

	#Debugging values
	echo "$DBUS_VOLUME_VALUE_CURRENT"
	echo "$DBUS_VOLUME_VALUE_NEWEST"
}

system_dbus_volume_increase(){
	local DBUS_VOLUME_VALUE_CURRENT=$(system_dbus_volume_current)
	local DBUS_VOLUME_VALUE_NEWEST=$(bc<<<"$DBUS_VOLUME_VALUE_CURRENT + $DBUS_VOLUME_DIFF")

	#Apply the new volume value
	local DBUS_CMD="org.freedesktop.DBus.Properties.Set string:${DBUS_DOMAIN}.Player string:Volume variant:double:$DBUS_VOLUME_VALUE_NEWEST"
	system_dbus_send_command $DBUS_CMD

	#Debugging values
	echo "$DBUS_VOLUME_VALUE_CURRENT"
	echo "$DBUS_VOLUME_VALUE_NEWEST"
}

#MUST BE FIXED
system_dbus_lyrics(){
	#$TERM -e lyrics $DBUS_PLAYER
	#alacritty -e lyrics $DBUS_PLAYER
	sleep 0.1
	alacritty -e lyrics $DBUS_PLAYER > /dev/null 2>&1 &
}

#############################
#Dedicated functions for Polybar
#############################

polybar_display(){
	system_dbus_display
}

polybar_click_left(){
	system_dbus_play_pause
}

polybar_click_middle(){
    system_dbus_volume_normal
}

polybar_click_right(){
	system_dbus_lyrics
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

polybar_scroll_up(){
	system_dbus_volume_increase
}

polybar_scroll_down(){
	system_dbus_volume_decrease
}

#############################
#Calling the functions
#############################

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"--info" | "--system-dbus-info") system_dbus_info ;;
	"--show" | "--system-dbus-display") system_dbus_display ;;
	"--prev" | "--system-dbus-previous") system_dbus_previous ;;
	"--play" | "--system-dbus-play-pause") system_dbus_play_pause ;;
	"--next" | "--system-dbus-next") system_dbus_next ;;
	"--get" | "--system-dbus-current-player") system_dbus_current_player ;;
	"--s-b" | "--system-dbus-skip-backward") system_dbus_skip_backward ;;
	"--s-f" | "--system-dbus-skip-forward") system_dbus_skip_forward ;;
	"--vol" | "--system-dbus-volume-current") system_dbus_volume_current ;;
	"--down" | "--system-dbus-volume-decrease") system_dbus_volume_decrease ;;
	"--normal" | "--system-dbus-volume-normal") system_dbus_volume_normal ;;
	"--up" | "--system-dbus-volume-increase") system_dbus_volume_increase ;;
	"--lyrics" | "--system-dbus-lyrics") system_dbus_lyrics ;;
	#Calling the dedicate Polybar functions
    "--polybar-display") polybar_display ;;
    "--polybar-click-left") polybar_click_left ;;
    "--polybar-click-middle") polybar_click_middle ;;
    "--polybar-click-right") polybar_click_right ;;
    "--polybar-double-click-left") polybar_double_click_left ;;
    "--polybar-double-click-middle") polybar_double_click_middle ;;
    "--polybar-double-click-right") polybar_double_click_right ;;
	"--polybar-scroll-up") polybar_scroll_up ;;
	"--polybar-scroll-down") polybar_scroll_down ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac