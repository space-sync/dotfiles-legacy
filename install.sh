#!usr/bin/env sh

if [[ $UID != 0 ]]; then
	echo -e "You must be root for preduring this installation!"
	exit 0;
fi

#Download the lastest dotfile binary release
curl `curl -s https://api.github.com/repos/henrikbeck95/dotfiles/releases/latest | grep browser_download_url | cut -d '"' -f 4` -O /usr/local/bin/dotfile

#Give the executabe permission
chmod +x /usr/local/bin/dotfile
