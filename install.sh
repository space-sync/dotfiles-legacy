#!/usr/bin/env sh

#Verify is user is root
if [[ $UID != 0 ]]; then
	echo -e "You must be root for preduring this installation!"
	exit 0;
fi

#############################
#Declaring the variables
#############################

OUTPUT_FILE_PATH_DOTFILES="/usr/local/bin"
OUTPUT_FILE_NAME_DOTFILES="dotfiles"

OUTPUT_FILE_PATH_LOGS="/var/log"
OUTPUT_FILE_NAME_LOGS="dotfiles"

LINK_RELEASE_LATEST=$(curl -s https://api.github.com/repos/henrikbeck95/dotfiles/releases/latest | grep browser_download_url | cut -d '"' -f 4)
OUTPUT_FILE_NAME="dotfiles"

#############################
#Functions
#############################

tools_download_version_latest_github(){
	cd /tmp/
	curl -L --proto '=https' --tlsv1.2 -sSf $1 --output $2 --silent
	cd - #Go back to the directory where the user was
}

tools_extract_file(){
	unzip $1
}

tools_remove_old_file(){
	if [[ -f $1 ]]; then
		rm -f $1
	fi
}

tools_move_file(){
	mv $1 $2
}

tools_give_executable_permission(){
	chmod 755 $1
}

tools_clear_temporary_file(){
	if [[ -d $1 ]]; then
		rm -fr $1
	elif [[ -f $1 ]]; then
		rm -f $1
	fi
}

#############################
#Calling the functions
#############################

tools_download_version_latest_github $LINK_RELEASE_LATEST $OUTPUT_FILE_NAME
#tools_extract_file $OUTPUT_FILE_NAME

tools_remove_old_file $OUTPUT_FILE_PATH_DOTFILES/$OUTPUT_FILE_NAME_DOTFILES
tools_remove_old_file $OUTPUT_FILE_PATH_LOGS/$OUTPUT_FILE_NAME_LOGS

#tools_move_file $OUTPUT_FILE_NAME_DOTFILES $OUTPUT_FILE_PATH_DOTFILES
tools_move_file /tmp/$OUTPUT_FILE_NAME_DOTFILES $OUTPUT_FILE_PATH_DOTFILES/$OUTPUT_FILE_NAME_DOTFILES
touch $OUTPUT_FILE_PATH_LOGS/$OUTPUT_FILE_NAME_LOGS

tools_give_executable_permission $OUTPUT_FILE_PATH_DOTFILES/$OUTPUT_FILE_NAME_DOTFILES
tools_give_executable_permission $OUTPUT_FILE_PATH_LOGS/$OUTPUT_FILE_NAME_LOGS

#tools_clear_temporary_file /tmp/$OUTPUT_FILE_NAME

#Execute the Dotfile
#$OUTPUT_FILE_PATH/$OUTPUT_FILE_NAME --install
