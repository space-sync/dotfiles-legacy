#!/usr/bin/env sh

#############################
#Declaring variables
#############################

AUX1=$1

TERMINAL_COLOR_EMPTY="FFFFFF"
TERMINAL_COLOR_FULL="0A81F5"
TERMINAL_ICON=""
#TERMINAL_ICON=""

TRASH_FILE_PATH="$HOME/.local/share/Trash/files"
TRASH_INFO_PATH="$HOME/.local/share/Trash/info"

MESSAGE_HELP="
\t\t\t\tSystem trash
\t\t\t\t------------\n
[Description]
Manage trash files from command line interface (CLI)

[Dependencies]
Trash-cli

[Parameters]
-h\t\t--help\t-?\t\t\tDisplay this help message
-e\t\t--edit\t\t\t\tEdit this script file
--display\t--trash-display\t\t\tDisplay trash icon
--tce\t\t--trash-check-empty\t\tCheck if trash is empty
--create\t--trash-create\t\t\t(Re)create the trash directories
--list\t\t--trash-list\t\t\tList all the trash files
--clean\t\t--trash-clean\t\t\tClear all the trash files
--restore\t--trash-restore\t\t\tRestore all the trash files
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_HELP"

#############################
#Functions
#############################

TERMINAL_COLOR_EMPTY="FFFFFF"
TERMINAL_COLOR_FULL="0A81F5"
TERMINAL_ICON=""

trash_display(){
    local IS_TRASH_EMPTY=$(trash_check_empty)

    if [[ $IS_TRASH_EMPTY == "true" ]]; then
        echo -e ""
    else
        local TERMINAL_COLOR=$TERMINAL_COLOR_FULL
        echo -e "%{F#$TERMINAL_COLOR}${TERMINAL_ICON}"
    fi
}

trash_check_empty(){
    local TRASH_FILES_COUNT=$(trash-list | wc -l)
    
    if [[ $TRASH_FILES_COUNT -gt 0 ]]; then
        local IS_TRASH_EMPTY="false"
    else
        local IS_TRASH_EMPTY="true"
    fi

    #Return
    echo "$IS_TRASH_EMPTY"
}

trash_create(){
    mkdir -p $TRASH_FILE_PATH/
    mkdir -p $TRASH_INFO_PATH/
}

trash_list(){
    trash-list
}

trash_clean(){
    #Check if $TRASH_FILE_PATH/ directory exists
    if [[ -d $TRASH_FILE_PATH/ ]]; then
        rm -rf $TRASH_FILE_PATH/
    fi

    #Check if $TRASH_INFO_PATH/ directory exists
    if [[ -d $TRASH_INFO_PATH/ ]]; then
        rm -rf $TRASH_INFO_PATH/
    fi
    
    trash_create

    #trash-empty
}

trash_restore(){
    trash-restore
}

#############################
#Calling the functions
#############################

case $AUX1 in
    "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
    "-e" | "--edit") $EDITOR $0 ;;
    "" | "--display" | "--trash-display") trash_display ;;
    "--tce" | "--trash-check-empty") trash_check_empty ;;
    "--create" | "--trash-create") trash_create ;;
    "--list" | "--trash-list") trash_list ;;
    "--clean" | "--trash-clean") trash_clean ;;
    "--restore" | "--trash-restore") trash_restore ;;
    *) echo -e "$MESSAGE_ERROR" ;;
esac