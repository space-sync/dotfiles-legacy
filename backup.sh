#!/usr/bin/env sh

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
\t\t\tDotfiles backup tool
\t\t\t--------------------\n
-h\t--help\t-?\t\t\tDisplay this help message
-e\t--edit\t\t\t\tEdit this script file
-bc\t--backup-create\t\t\tCreate a Dotfiles backup
-bl\t--backup-list\t\t\tList the Dotfiles backups
-br\t--backup-restore\t\tRestore a Dotfile backup
-r\t--replace\t\t\tReplace the current dotfiles by the compiled ones
"

MESSAGE_BACKUP_NOT_AVAILABLE="No backup availables! How about creating an one!?"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_ERROR"

tools_backup_create(){
	local DATE_TIMESTAMP=$(date +%s)
	mkdir -p $PATH_DOTFILE_BACKUP/$DATE_TIMESTAMP/
	cp $PATH_DOTFILE/* $PATH_DOTFILE_BACKUP/$DATE_TIMESTAMP/
}

tools_backup_list(){
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
tools_backup_restore(){
	#Get last backup version
	local BACKUP_VERSION_LATEST=$(ls $PATH_DOTFILE_BACKUP/ | tail -1)

	#Replace the current version by the backup version
	cp $PATH_DOTFILE_BACKUP/$BACKUP_VERSION_LATEST/* $PATH_DOTFILE/
}

#MUST BE TESTED
tools_replace_current(){
	tools_backup_create
	cp $PATH_DOTFILE_COMPILED/* $PATH_DOTFILE/
}

clear

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;;
	"-bc" | "--backup-create") tools_backup_create ;;
	"-bl" | "--backup-list") tools_backup_list ;;
	"-br" | "--backup-restore") tools_backup_restore ;;
	"-r" | "--replace") tools_replace_current ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
