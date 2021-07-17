#!/bin/sh

#############################
#Declaring the variables
#############################

AUX1=$1

LINK_REPOSITORY="https://github.com/henrikbeck95/dotfiles.git"
PATH_REPOSITORY=$HOME/.dotfile
PATH_DOTFILE=$PATH_REPOSITORY/src
#PATH_DOTFILE_LOG=$HOME/.dotfile.log
PATH_DOTFILE_LOG=/var/log/dotfile
PATH_DOTFILE_LOG_TEMP=/tmp/dotfile_log_temp
PATH_DOTFILE_REMOVE=/tmp/dotfile_log_remove
PATH_SCRIPT=${BASH_SOURCE%}
#PATH_SCRIPT=$_

MESSAGE_HELP="
\t-------------------------------------
\t\t***DOTFILES MANAGER***
\t-------------------------------------

Be sure you really want to do this procedure.
This software is going to replace your dotfiles.
So, consider to backup your dotfiles before moving forward.

\t-------------------------------------
\tCommand line interface commands list
\t-------------------------------------

-h,\t--help, -?\t\tDisplay this help message
-c,\t--commit\t\tCommit the dotfiles stage (NOT IMPLEMENTED YET)
-b,\t--backup\t\tBackup the files (NOT IMPLEMENTED YET)
-e,\t--edit\t\t\tEdit this file
-i,\t--install\t\tApply dotfiles
-l,\t--list\t\t\tList all linked dotfiles
-r,\t--remove\t\tRemove dotfiles (IMPLEMENTING)
-rr,\t--remove-all\t\tRemove all dotfiles
-u,\t--update\t\tUpdate dotfiles"

#dotfiles_remove_all
MESSAGE_ERROR="This is an invalid argument for $0!\n\n$MESSAGE_HELP"

#############################
#Functions
#############################

dotfiles_install(){
	dotfiles_remove

	echo -e "Installing Henrik Beck's dotfiles..."
	git clone $LINK_REPOSITORY $PATH_REPOSITORY

	dotfiles_update
}

dotfiles_list(){
	echo -e ""
	cat $PATH_DOTFILE_LOG | awk '{print $0}'
}

dotfiles_update(){
	cat /dev/null > $PATH_DOTFILE_LOG_TEMP #Clear all the log file
	echo -e "Application|Dotfile path" >> $PATH_DOTFILE_LOG_TEMP
	echo -e "---|---" >> $PATH_DOTFILE_LOG_TEMP

	apply_alacritty
	apply_bash
	apply_feh
	apply_htop
	apply_lf
	apply_sxhkd
	apply_tmux
	apply_tmux_tpm
	apply_tty
	apply_vim
	apply_vim_vundle
	apply_xresources

	column -t -s '|' $PATH_DOTFILE_LOG_TEMP > $PATH_DOTFILE_LOG
}

dotfiles_remove(){
	if [[ -f $PATH_DOTFILE_LOG ]]; then
		#Generate $PATH_DOTFILE_REMOVE file
		cat $PATH_DOTFILE_LOG | awk '{print $2}' | tail -n +3 > $PATH_DOTFILE_REMOVE

		#Remove each dotfile from the lines of the $PATH_DOTFILE_REMOVE file
		while read file_line; do
			if [[ -f $file_line ]]; then
				echo -e "Removing $file_line old dotfiles..."
				rm -f $file_line
			elif [[ -f $file_line ]]; then
				echo -e "Removing $file_line old dotfiles..."
				rm -fr $file_line
			fi
		done < $PATH_DOTFILE_REMOVE
	fi
}

dotfiles_remove_all(){
	if [[ -d $PATH_DOTFILE ]]; then
		echo -e "Removing Henrik Beck's old dotfiles..."
		rm -fr $PATH_DOTFILE/
	fi
	
	dotfiles_remove
}

apply_alacritty(){
	local APPLICATION_NAME="Alacritty"
	local APPLICATION_PATH="$HOME/.config/alacritty/alacritty.yml"

	display_message_applying "$APPLICATION_NAME"
	mkdir -p $HOME/.config/alacritty/
	ln -sf $PATH_DOTFILE/alacritty.yml $APPLICATION_PATH

	echo -e "$APPLICATION_NAME|$APPLICATION_PATH" >> $PATH_DOTFILE_LOG_TEMP
}

apply_bash(){
	local APPLICATION_NAME="Bash"
	local APPLICATION_PATH="$HOME/.bashrc"

	display_message_applying "$APPLICATION_NAME"
	ln -sf $PATH_DOTFILE/bashrc $APPLICATION_PATH

	echo -e "$APPLICATION_NAME|$APPLICATION_PATH" >> $PATH_DOTFILE_LOG_TEMP
}

apply_feh(){
	local APPLICATION_NAME="Feh"
	local APPLICATION_PATH="$HOME/.fehbg"

	display_message_applying "$APPLICATION_NAME"
	ln -sf $PATH_DOTFILE/fehbg $APPLICATION_PATH

	echo -e "$APPLICATION_NAME|$APPLICATION_PATH" >> $PATH_DOTFILE_LOG_TEMP
}

apply_htop(){
	local APPLICATION_NAME="HTop"
	local APPLICATION_PATH="$HOME/.config/htop/htoprc"

	display_message_applying "$APPLICATION_NAME"
	mkdir -p $HOME/.config/htop/
	ln -sf $PATH_DOTFILE/htoprc $APPLICATION_PATH

	echo -e "$APPLICATION_NAME|$APPLICATION_PATH" >> $PATH_DOTFILE_LOG_TEMP
}

apply_lf(){
	local APPLICATION_NAME="Lf"
	local APPLICATION_PATH="$HOME/.config/lf/lfrc"

	display_message_applying "$APPLICATION_NAME"
	mkdir -p $HOME/.config/lf/
	ln -sf $PATH_DOTFILE/lfrc $APPLICATION_PATH

	echo -e "$APPLICATION_NAME|$APPLICATION_PATH" >> $PATH_DOTFILE_LOG_TEMP
}

apply_sxhkd(){
	local APPLICATION_NAME="Sxhkd"
	local APPLICATION_PATH="$HOME/.config/sxhkd/sxhkdrc"

	display_message_applying "$APPLICATION_NAME"
	mkdir -p $HOME/.config/sxhkd/
	ln -sf $PATH_DOTFILE/sxhkdrc $APPLICATION_PATH

	echo -e "$APPLICATION_NAME|$APPLICATION_PATH" >> $PATH_DOTFILE_LOG_TEMP
}

apply_tmux(){
	local APPLICATION_NAME="Tmux"
	local APPLICATION_PATH="$HOME/.tmux.conf"

	display_message_applying "$APPLICATION_NAME"

	ln -sf $PATH_DOTFILE/tmux.conf $APPLICATION_PATH
	#tmux source $APPLICATION_PATH && run -b $HOME/.tmux/plugins/tpm/tpm

	echo -e "$APPLICATION_NAME|$APPLICATION_PATH" >> $PATH_DOTFILE_LOG_TEMP
}

#############################
#MUST BE FIXED
#############################

apply_tmux_tpm(){
	local APPLICATION_NAME="TmuxPluginManager"
	local APPLICATION_PATH="$HOME/.tmux/plugins/tpm/"

	display_message_applying "$APPLICATION_NAME"

	if [[ -d $APPLICATION_PATH ]]; then
		echo -e "Removing $APPLICATION_NAME old dotfiles..."
		rm -fr $APPLICATION_PATH
	fi

	git clone https://github.com/tmux-plugins/tpm $APPLICATION_PATH

	ln -sf $PATH_DOTFILE/tmux_network.sh $HOME/.tmux/plugins/tmux/scripts/network.sh
	#wait ln -sf $PATH_DOTFILE/tmux_network.sh $HOME/.tmux/plugins/tmux/scripts/network.sh
	#tmux source $APPLICATION_PATH && run -b $HOME/.tmux/plugins/tpm/tpm

	echo -e "$APPLICATION_NAME|$APPLICATION_PATH" >> $PATH_DOTFILE_LOG_TEMP
}

apply_tty(){
	local APPLICATION_NAME="TTY"
	local APPLICATION_PATH="$HOME/.profile"

	display_message_applying "$APPLICATION_NAME"
	ln -sf $PATH_DOTFILE/profile $APPLICATION_PATH

	echo -e "$APPLICATION_NAME|$APPLICATION_PATH" >> $PATH_DOTFILE_LOG_TEMP
}

apply_vim(){
	local APPLICATION_NAME="Vim"
	local APPLICATION_PATH="$HOME/.vimrc"

	display_message_applying "$APPLICATION_NAME"
	ln -sf $PATH_DOTFILE/vimrc $APPLICATION_PATH

	echo -e "$APPLICATION_NAME|$APPLICATION_PATH" >> $PATH_DOTFILE_LOG_TEMP
}

apply_vim_vundle(){
	local APPLICATION_NAME="Vim-Vundle"
	local APPLICATION_PATH="$HOME/.vim/bundle/Vundle.vim/"

	display_message_applying "$APPLICATION_NAME"

	if [[ -d $APPLICATION_PATH ]]; then
		echo -e "Removing $APPLICATION_NAME old dotfiles..."
		rm -fr $APPLICATION_PATH
	fi

	git clone https://github.com/VundleVim/Vundle.vim.git $APPLICATION_PATH
	vim +PluginInstall +qall

	echo -e "$APPLICATION_NAME|$APPLICATION_PATH" >> $PATH_DOTFILE_LOG_TEMP
}

apply_xresources(){
	local APPLICATION_NAME="Xresources"
	local APPLICATION_PATH="$HOME/.Xresources"

	display_message_applying "$APPLICATION_NAME"
	ln -sf $PATH_DOTFILE/Xresources $APPLICATION_PATH
	xrdb -merge $APPLICATION_PATH

	echo -e "$APPLICATION_NAME|$APPLICATION_PATH" >> $PATH_DOTFILE_LOG_TEMP
}

display_message_applying(){
	echo -e "Applying $1 settings..."
}

#############################
#Calling the functions
#############################

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;;
	"-i" | "--install") dotfiles_install ;;
	"-l" | "--list") dotfiles_list ;;
	"-r" | "--remove") dotfiles_remove ;;
	"-rr" | "--remove-all") dotfiles_remove_all ;;
	"-u" | "--update") dotfiles_update ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
