#!/usr/bin/env sh

#Verify is user is root
if [[ $UID != 0 ]]; then
	echo -e "You must be root for preduring this installation!"
	exit 0;
fi

#############################
#Declaring the variables
#############################

CURRENT_DIRECTORY=$(pwd)
OUTPUT_FILE_NAME="dotfile"
OUTPUT_FILE_PATH="/usr/local/bin"
VAR_LOG_PATH="/var/log/dotfile"
LINK_RELEASE_LATEST=$(curl -s https://api.github.com/repos/henrikbeck95/dotfiles/releases/latest | grep browser_download_url | cut -d '"' -f 4)

#############################
#Executing the commands
#############################

#Go to the directory where the file must be save
cd $OUTPUT_FILE_PATH

if [[ -f $OUTPUT_FILE_PATH/$OUTPUT_FILE_NAME ]]; then
	rm $OUTPUT_FILE_PATH/$OUTPUT_FILE_NAME
	rm $VAR_LOG_PATH
fi

#Download the lastest dotfile binary release file
curl -L --proto '=https' --tlsv1.2 -sSf $LINK_RELEASE_LATEST --output $OUTPUT_FILE_NAME --silent

#Go back to the directory where the user was
cd $CURRENT_DIRECTORY

#Give the executabe permission
chmod 755 $OUTPUT_FILE_PATH/$OUTPUT_FILE_NAME

#Create the log file
touch $VAR_LOG_PATH
chmod 777 $VAR_LOG_PATH

#Execute the Dotfile
#$OUTPUT_FILE_PATH/$OUTPUT_FILE_NAME --install
