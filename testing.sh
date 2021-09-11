#!/usr/bin/env sh

AUX1=$1

MESSAGE_HELP="
\t\t\t\tTesting
\t\t\t\t-------\n
-h\t--help\t-?\t\tDisplay this help message
-e\t--edit\t\t\tEdit this script file
-x\t--xxx\t\t\tCompile, link file and apply i3 settings
"

MESSAGE_ERROR="Invalid option for $0!\n$MESAGE_HELP"

compilation_dotfiles(){
	#/home/joker/.dotfiles/compilation.sh -c-i3
	/home/joker/.dotfiles/compilation.sh -c-all
}

link_file_cava(){
	mkdir -p $HOME/.config/cava/

	ln -sf \
		/home/joker/.dotfiles/compiled/cava.conf \
		/home/joker/.config/cava/config
}

link_file_i3(){
	mkdir -p $HOME/.config/i3/

	ln -sf \
		/home/joker/.dotfiles/compiled/i3.conf \
		/home/joker/.config/i3/config
}

link_file_picom(){
	mkdir -p $HOME/.config/picom/

	ln -sf \
		/home/joker/.dotfiles/compiled/picom.conf \
		/home/joker/.config/picom/picom.config
}

link_file_polybar(){
	mkdir -p $HOME/.config/polybar/

	ln -sf \
		/home/joker/.dotfiles/compiled/polybar.conf \
		/home/joker/.config/polybar/config
}

apply_i3(){
	i3 reload
	i3 restart
}

xxx(){
	compilation_dotfiles
	link_file_cava
	link_file_i3
	link_file_picom
	link_file_polybar

	apply_i3
}

clear

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;;
	"-x" | "--xxx") xxx ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
