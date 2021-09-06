#!/bin/bash

#############################
#Global variables
#############################

#_BEGIN_FILENAME="my-startup"
#_BEGIN_FILENAME="harpy-shark"
_BEGIN_FILENAME="lord"

_SBIN="/usr/local/sbin" #Shell script files in systemd folder
_SYSTEMD="/etc/systemd/system" #Services files in systemd folder
_DOTFILES="/usr/share/lord/scripts/systemd" #Where the custom files are.

_main(){
    # Make sure only root can run script
    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run as root" 1>&2
        exit 1
    fi

    #_backing_up
    _calling_remover_all
    _calling_setter_all
}

_backing_up(){
    cp $_SBIN/$_BEGIN_FILENAME*.sh $_DOTFILES/scripts/
    cp $_SYSTEMD/$_BEGIN_FILENAME*.service $_DOTFILES/services/
}

_copying_to_systemd(){
    cp $_DOTFILES/scripts/$_BEGIN_FILENAME*.sh $_SBIN/
    cp $_DOTFILES/services/$_BEGIN_FILENAME*.service $_SYSTEMD/
}

_permitting(){
    sudo chmod +x $_SBIN/$_BEGIN_FILENAME*.sh
}

_removing(){
    rm $_SBIN/$_BEGIN_FILENAME*.sh
    rm $_SYSTEMD/$_BEGIN_FILENAME*.service
}

_listing(){
    echo -e "\n---***SBIN***---"
    ls $_SBIN | grep "^$_BEGIN_FILENAME"

    echo -e "\n---***SYSTEMD***---"
    ls $_SYSTEMD | grep "^$_BEGIN_FILENAME"

    echo -e "\n---***#***---"
}

_systemd_service_management(){
    #Preparing the sed regex
    _path="$_SYSTEMD/"
    _path_length="s/.\{${#_path}\}//"
    
    _filename="$_BEGIN_FILENAME"
    _filename_length="s/.\{${#_filename}\}//"
    
    #Mapping the files names
    for _i in "$_SYSTEMD"/*
    do
        _aux=$(echo "$_i" | sed $_path_length | grep "^$_BEGIN_FILENAME" | sed $_filename_length)

        if [ ! -z "$_aux" ]; then
            #_systemd_testing $_aux $_path_length $_filename_length
            _systemd_enabling $_aux
            #_systemd_disabling $_aux
            _systemd_status $_aux
        fi
    done
}

_systemd_testing(){
    echo "Path length = $_path_length"
    echo "Filename length = $_filename_length"
    echo "sudo systemctl enable $_BEGIN_FILENAME$_aux";
}

_systemd_enabling(){
    sudo systemctl enable $_BEGIN_FILENAME$_aux
}

_systemd_disabling(){
    sudo systemctl disable $_BEGIN_FILENAME$_aux
}

_systemd_status(){
    systemctl status $_BEGIN_FILENAME$_aux
}

#############################
#Executables
#############################

## Coding
#---Creating a systemd startup process
###: 1595684149:0;touch /etc/inid.d/chown_brightness.sh

#sudo vim /usr/local/sbin/my-startup.sh
#sudo chmod +x /usr/local/sbin/my-startup.sh
#sudo vim /etc/systemd/system/my-startup.service
#systemctl status my-startup.service
#sudo systemctl enable my-startup.service
#systemctl status my-startup.service

_calling_remover_all(){
    _removing
    _listing

    ls $_SBIN
    ls $_SYSTEMD
}

_calling_setter_all(){
    _copying_to_systemd
    _permitting
    _listing
    _systemd_service_management
    
    ls $_SBIN
    ls $_SYSTEMD
}

_main