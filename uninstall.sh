#!/usr/bin/env sh

#Verify is user is root
if [[ $UID != 0 ]]; then
	echo -e "You must be root for preduring this installation!"
	exit 0;
fi

#Remove log file
rm -f /var/log/dotfile

#Remove Dotfile binary file
rm -f /usr/local/bin/dotfile
