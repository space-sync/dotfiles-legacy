#!/usr/bin/env sh

AUX1=$1

PATH_SCRIPT=$(pwd)
DOTFILES_COMPILED="$PATH_SCRIPT/compiled"
DOTFILES_CURRENT="$PATH_SCRIPT/current"

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

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_ERROR"

tools_backup_create(){
	#local DATE_TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
	local DATE_TIMESTAMP=$(date +%s)
	local DOTFILES_BACKUP="$PATH_SCRIPT/backup/$DATE_TIMESTAMP"

	mkdir -p $DOTFILES_BACKUP/
	cp $DOTFILES_CURRENT/* $DOTFILES_BACKUP/
}

tools_backup_list(){
	for BACKUP_VERSION in $(ls $DOTFILES_BACKUP/); do
		local DATE_TIMESTAMP_VERSION="$BACKUP_VERSION"
		local DATE_TIMESTAMP_REVERSE=$(date -d "@$DATE_TIMESTAMP_VERSION")
		echo -e "$DATE_TIMESTAMP_VERSION:\t$DATE_TIMESTAMP_REVERSE"
	done;
}

tools_backup_restore(){
	#Get last backup version
	local BACKUP_VERSION_LATEST=$(ls $DOTFILES_BACKUP/ | tail -1)

	#Replace the current version by the backup version
	cp $DOTFILES_BACKUP/$BACKUP_VERSION_LATEST/* $DOTFILES_CURRENT/
}

tools_replace_current(){
	tools_backup_create
	cp $DOTFILES_COMPILED/* $DOTFILES_CURRENT/
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
