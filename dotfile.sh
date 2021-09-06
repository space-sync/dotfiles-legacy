#!/usr/bin/env sh

#############################
#Declaring the variables
#############################

AUX1=$1

LINK_REPOSITORY="https://github.com/henrikbeck95/dotfiles.git"
PATH_REPOSITORY=$HOME/.dotfiles
#PATH_DOTFILE=$PATH_REPOSITORY/src
PATH_DOTFILE=$PATH_REPOSITORY/current
PATH_DOTFILE_LOG=/var/log/dotfiles
PATH_DOTFILE_LOG_TEMP=/tmp/dotfiles_log_temp
PATH_DOTFILE_REMOVE=/tmp/dotfiles_log_remove

#Testing
PATH_DOTFILE_BACKUP=$PATH_REPOSITORY/backup
PATH_DOTFILE_COMPILED="$PATH_REPOSITORY/compiled"
PATH_DOTFILE_CURRENT=""

MESSAGE_HELP="
\t\t\tDotfiles manager
\t\t\t----------------\n
[Description]
This is a plain text configuration files manager used by the softwares for loading their settings.

[Warnings]
Be sure you really want to do this procedure.
This software is going to replace your dotfiles.
So, consider to backup your dotfiles before moving forward.

[Parameters]
-h,\t--help, -?\t\t\tDisplay this help message
-e\t--edit\t\t\t\tEdit this script file
-bc\t--backup-create\t\t\tCreate a Dotfiles backup
-bl\t--backup-list\t\t\tList the Dotfiles backups
-br\t--backup-restore\t\tRestore a Dotfile backup
#-cd\t--compile-dotfile\t\tCompile dotfiles (NOT IMPLEMENTED YET)
-cr\t--compile-replace\t\tReplace the current dotfiles by the compiled ones
-di,\t--dotfile-install\t\tApply dotfiles
-dl,\t--dotfile-list\t\t\tList all linked dotfiles
-dr,\t--dotfile-remove\t\tRemove dotfiles
-dra,\t--dotfile-remove-all\t\tRemove all dotfiles
-du,\t--dotfile-update\t\tUpdate dotfiles
"

MESSAGE_BACKUP_NOT_AVAILABLE="No backup availables!"

MESSAGE_ERROR="This is an invalid argument for $0!\n\n$MESSAGE_HELP"

#############################
#Functions
#############################

tools_convert_string_to_lowercase(){
	echo "$1" | tr '[:upper:]' '[:lower:]'
}

tools_check_if_software_is_installed(){
	local SOFTWARE_NAME=$(tools_convert_string_to_lowercase "$1")
	echo "$SOFTWARE_NAME"

	if [ -x "$(command -v $SOFTWARE_NAME)" ]; then
		#echo "$SOFTWARE_NAME is installed." >&2
		return 0
	else
		#echo "Error: $SOFTWARE_NAME is not installed." >&2
		return 1
	fi
}

dotfiles_backup_create(){
	local DATE_TIMESTAMP=$(date +%s)
	mkdir -p $PATH_DOTFILE_BACKUP/$DATE_TIMESTAMP/
	cp $PATH_DOTFILE/* $PATH_DOTFILE_BACKUP/$DATE_TIMESTAMP/
}

dotfiles_backup_list(){
	#Check if there is/are backup(s) available
	if [[ ! -d $PATH_DOTFILE_BACKUP/ ]];then
		echo -e "$MESSAGE_BACKUP_NOT_AVAILABLE\nDirectory does not exists."
	elif [[ -z "$(ls -A $PATH_DOTFILE_BACKUP/)" ]];then
		echo -e "$MESSAGE_BACKUP_NOT_AVAILABLE\nThere is/are no backup(s) file(s) in directory."
	else
		for BACKUP_VERSION in $(ls $PATH_DOTFILE_BACKUP/); do
			local DATE_TIMESTAMP_VERSION="$BACKUP_VERSION"
			local DATE_TIMESTAMP_REVERSE=$(date -d "@$DATE_TIMESTAMP_VERSION")
			echo -e "$DATE_TIMESTAMP_VERSION:\t$DATE_TIMESTAMP_REVERSE"
		done;
	fi
}

#MUST BE TESTED
dotfiles_backup_restore(){
	#Get last backup version
	local BACKUP_VERSION_LATEST=$(ls $PATH_DOTFILE_BACKUP/ | tail -1)

	#Replace the current version by the backup version
	cp $PATH_DOTFILE_BACKUP/$BACKUP_VERSION_LATEST/* $PATH_DOTFILE/
}

#MUST BE TESTED
dotfiles_replace_current(){
	tools_backup_create
	cp $PATH_DOTFILE_COMPILED/* $PATH_DOTFILE/
}

dotfiles_install(){
	dotfiles_remove

	if [[ ! -d $PATH_REPOSITORY ]]; then
		echo -e "Installing Henrik Beck's dotfiles..."
		git clone $LINK_REPOSITORY $PATH_REPOSITORY
	fi

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

	tools_check_if_software_is_installed "Alacritty"
	[ $? == 0 ] && apply_alacritty

	tools_check_if_software_is_installed "Bash"
	[ $? == 0 ] && apply_bash

	tools_check_if_software_is_installed "Feh"
	[ $? == 0 ] && apply_feh

	tools_check_if_software_is_installed "HTop"
	[ $? == 0 ] && apply_htop

	tools_check_if_software_is_installed "LF"
	[ $? == 0 ] && apply_lf

	tools_check_if_software_is_installed "SXHKD"
	[ $? == 0 ] && apply_sxhkd

	tools_check_if_software_is_installed "Tmux"
	[ $? == 0 ] && apply_tmux
	[ $? == 0 ] && apply_tmux_tpm

	tools_check_if_software_is_installed "TTY"
	[ $? == 0 ] && apply_tty

	tools_check_if_software_is_installed "Vim"
	[ $? == 0 ] && apply_vim
	[ $? == 0 ] && apply_vim_vundle

	tools_check_if_software_is_installed "xrdb"
	[ $? == 0 ] && apply_xresources

	column -t -s '|' $PATH_DOTFILE_LOG_TEMP > $PATH_DOTFILE_LOG
	rm $PATH_DOTFILE_LOG_TEMP
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

	rm $PATH_DOTFILE_REMOVE
}

dotfiles_remove_all(){
	if [[ -d $PATH_DOTFILE ]]; then
		echo -e "Removing Henrik Beck's old dotfiles..."
		rm -fr $PATH_REPOSITORY/
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

apply_tmux_tpm(){
	local APPLICATION_NAME="TmuxPluginManager"
	local APPLICATION_PATH="$HOME/.tmux/plugins/tpm/"

	display_message_applying "$APPLICATION_NAME"

	if [[ -d $APPLICATION_PATH ]]; then
		echo -e "Removing $APPLICATION_NAME old dotfiles..."
		rm -fr $APPLICATION_PATH
	fi

	git clone https://github.com/tmux-plugins/tpm $APPLICATION_PATH

	#############################
	#MUST BE FIXED
	#This process is being executed before the last process gets completed
	ln -sf $PATH_DOTFILE/tmux_network.sh $HOME/.tmux/plugins/tmux/scripts/network.sh
	#wait ln -sf $PATH_DOTFILE/tmux_network.sh $HOME/.tmux/plugins/tmux/scripts/network.sh
	#tmux source $APPLICATION_PATH && run -b $HOME/.tmux/plugins/tpm/tpm
	#############################

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

clear

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;;
	"-bc" | "--backup-create") dotfiles_backup_create ;;
	"-bl" | "--backup-list") dotfiles_backup_list ;;
	"-br" | "--backup-restore") dotfiles_backup_restore ;;
	#"-cd" | "--compile-dotfile" ??? ;;
	"-cr" | "--compile-replace") dotfiles_replace_current ;;
	"-di" | "--dotfile-install") dotfiles_install ;;
	"-dl" | "--dotfile-list") dotfiles_list ;;
	"-dr" | "--dotfile-remove") dotfiles_remove ;;
	"-dra" | "--dotfile-remove-all") dotfiles_remove_all ;;
	"-du" | "--dotfile-update") dotfiles_update ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
