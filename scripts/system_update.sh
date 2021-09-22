#!/usr/bin/env sh

#############################
#Declaring variables
#############################

AUX1=$1

LINUX_DISTRO_BASED=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)

TERMINAL_COLOR_UPDATED="FFFFFF"
TERMINAL_COLOR_NOT_UPDATED="0A81F5"
TERMINAL_ICON=""

MESSAGE_HELP="
[Description]
Display how many system package are up to be updated on your operating system

[Dependencies]
pacman-contrib, WC

[Parameters]
-h\t\t--help\t-?\t\t\t\tDisplay this help message
-e\t\t--edit\t\t\t\t\tEdit this script file
--apt\t\t--system-update-apt\t\t\tUpdate the packages from Debian/Ubuntu distro base
--dnf\t\t--system-update-dnf\t\t\tUpdate the packages from Fedora/RedHat distro base
--pacman\t--system-update-pacman\t\t\tUpdate the packages from ArchLinux distro base - official repository
--aur\t\t--system-update-aur\t\t\tUpdate the packages from ArchLinux distro base - ArchLinux User Repository (AUR)
--xbps\t\t--system-update-void\t\tUpdate the package from Void Linux distro base
--flatpak\t--system-update-flatpak\t\t\tUpdate the packages from Flatpaks
--show\t\t--system-update-display\t\tDisplay the system update icon if there is/are available packages to be updated
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_HELP"

#############################
#Functions
#############################

display_message_debug(){
    echo -e "Package manager: $1\t\t$2"
}

system_update_display(){
    local SYSTEM_UPDATE_AVAILABLE_COUNT_ARCHLINUX_OFFICIAL=$(system_update_archlinux)
    local SYSTEM_UPDATE_AVAILABLE_COUNT_ARCHLINUX_AUR=$(system_update_archlinux_aur)
    local SYSTEM_UPDATE_AVAILABLE_COUNT_DEBIAN=$(system_update_debian_ubuntu)
    local SYSTEM_UPDATE_AVAILABLE_COUNT_FEDORA=$(system_update_fedora)
    local SYSTEM_UPDATE_AVAILABLE_COUNT_VOID=$(system_update_void)
    local SYSTEM_UPDATE_AVAILABLE_COUNT_FLATPAK=$(system_update_flatpak)

    #Calculating how many packages have updates availables
    local SYSTEM_UPDATE_AVAILABLE_COUNT_ALL=$(($SYSTEM_UPDATE_AVAILABLE_COUNT_ARCHLINUX_OFFICIAL+$SYSTEM_UPDATE_AVAILABLE_COUNT_ARCHLINUX_AUR+$SYSTEM_UPDATE_AVAILABLE_COUNT_DEBIAN+$SYSTEM_UPDATE_AVAILABLE_COUNT_FEDORA+$SYSTEM_UPDATE_AVAILABLE_COUNT_VOID+$SYSTEM_UPDATE_AVAILABLE_COUNT_FLATPAK))

    #Debugging
    #display_message_debug "Advanced Package Tool (APT)" $SYSTEM_UPDATE_AVAILABLE_COUNT_DEBIAN
    #display_message_debug "Dandified Yum (DNF)" $SYSTEM_UPDATE_AVAILABLE_COUNT_FEDORA
    #display_message_debug "Package Manager (PacMan)" $SYSTEM_UPDATE_AVAILABLE_COUNT_ARCHLINUX_OFFICIAL
    #display_message_debug "Yet Another Yogurt (YAY)" $SYSTEM_UPDATE_AVAILABLE_COUNT_ARCHLINUX_AUR
    #display_message_debug "#X Binary Package System (XBPS)" $SYSTEM_UPDATE_AVAILABLE_COUNT_VOID
    #display_message_debug "Flatpak" $SYSTEM_UPDATE_AVAILABLE_COUNT_FLATPAK
    #echo -e "---------------------------------"
    #display_message_debug "all" $SYSTEM_UPDATE_AVAILABLE_COUNT_ALL

    #Display the system update icon
    if [ "$SYSTEM_UPDATE_AVAILABLE_COUNT_ALL" -gt 0 ]; then
        echo -e "%{F#$TERMINAL_COLOR_NOT_UPDATED}${TERMINAL_ICON}   $SYSTEM_UPDATE_AVAILABLE_COUNT_ALL"
    else
        echo -e ""
    fi
}

system_update_debian_ubuntu(){
    local SYSTEM_PACKAGE_MANAGER="apt"
    local SYSTEM_UPDATE_AVAILABLE_COUNT=$($SYSTEM_PACKAGE_MANAGER list --upgradable 2> /dev/null | grep -c upgradable)
    echo "$SYSTEM_UPDATE_AVAILABLE_COUNT" #Return
}

system_update_fedora(){
    local SYSTEM_PACKAGE_MANAGER="dnf"

    if [ -x "$(command -v $SYSTEM_PACKAGE_MANAGER)" ]; then
        local SYSTEM_UPDATE_AVAILABLE_COUNT=$($SYSTEM_PACKAGE_MANAGER updateinfo -q --list | wc -l)
    else
        local SYSTEM_UPDATE_AVAILABLE_COUNT=0
    fi

    echo "$SYSTEM_UPDATE_AVAILABLE_COUNT" #Return
}

system_update_archlinux(){
    local SYSTEM_PACKAGE_MANAGER="pacman"

    if [ -x "$(command -v $SYSTEM_PACKAGE_MANAGER)" ]; then
        local SYSTEM_UPDATE_AVAILABLE_COUNT=$($SYSTEM_PACKAGE_MANAGER -Qun 2> /dev/null | wc -l)
    else
        local SYSTEM_UPDATE_AVAILABLE_COUNT=0
    fi

    echo "$SYSTEM_UPDATE_AVAILABLE_COUNT" #Return
}

system_update_archlinux_aur(){
    local SYSTEM_PACKAGE_MANAGER="paru"
    #local SYSTEM_PACKAGE_MANAGER="yay"

    if [ -x "$(command -v $SYSTEM_PACKAGE_MANAGER)" ]; then
        local SYSTEM_UPDATE_AVAILABLE_COUNT=$($SYSTEM_PACKAGE_MANAGER -Qum 2> /dev/null | wc -l)
    else
        local SYSTEM_UPDATE_AVAILABLE_COUNT=0
    fi

    echo "$SYSTEM_UPDATE_AVAILABLE_COUNT" #Return
}

system_update_void(){
    local SYSTEM_PACKAGE_MANAGER="xbps"

    if [ -x "$(command -v $SYSTEM_PACKAGE_MANAGER)" ]; then
        local SYSTEM_UPDATE_AVAILABLE_COUNT=$($SYSTEM_PACKAGE_MANAGER-install -Mun 2> /dev/null | wc -l)
    else
        local SYSTEM_UPDATE_AVAILABLE_COUNT=0
    fi
    
    echo "$SYSTEM_UPDATE_AVAILABLE_COUNT" #Return
}

system_update_flatpak(){
    local SYSTEM_PACKAGE_MANAGER="flatpak"
    
    if [ -x "$(command -v $SYSTEM_PACKAGE_MANAGER)" ]; then
        local SYSTEM_UPDATE_AVAILABLE_COUNT=$($SYSTEM_PACKAGE_MANAGER update 2>/dev/null | tail -n +5 | head -2 | wc -l)
    else
        local SYSTEM_UPDATE_AVAILABLE_COUNT=0
    fi
    
    echo "$SYSTEM_UPDATE_AVAILABLE_COUNT" #Return
}

tool_system_update(){
    alacritty --hold -e $1 > /dev/null 2>&1 &
}

#MUST BE FIXED
system_update_packages(){
    case $LINUX_DISTRO_BASED in
        "alpine")
            tool_system_update "sudo pacman -Syyuu"
            tool_system_update "flatpak update"
            ;;
        "arch")
            tool_system_update "sudo pacman -Syyuu"
            tool_system_update "paru -Syyuu"
            #tool_system_update "yay -Syyuu"
            tool_system_update "flatpak update"
            ;;
        "debian" | "ubuntu")
            tool_system_update "sudo apt-get update"
            tool_system_update "sudo apt-get upgrade"
            tool_system_update "flatpak update"
            ;;
        "fedora" | "rhel")
            tool_system_update "sudo dnf update"
            tool_system_update "sudo dnf upgrade"
            tool_system_update "flatpak update"
            ;;
        "void")
            tool_system_update "xbps-install -Su"
            tool_system_update "flatpak update"
            ;;
        *) : ;;
    esac
}

#############################
#Dedicated functions for Polybar
#############################

polybar_display(){
    system_update_display
}

polybar_click_left(){
	system_update_packages
}

#############################
#Calling the functions
#############################

case $AUX1 in
    "" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
    "-e" | "--edit") $EDITOR $0 ;;
    "--apt" | "--system-update-apt") system_update_debian_ubuntu ;;
    "--dnf" | "--system-update-dnf") system_update_fedora ;;
    "--pacman" | "--system-update-pacman") system_update_archlinux ;;
    "--aur" | "--system-update-aur") system_update_archlinux_aur ;;
    "--xbps" | "--system-update-void") system_update_void ;;
    "--flatpak" | "--system-update-flatpak") system_update_flatpak ;;
    "--show" | "--system-update-display") system_update_display ;;
    #Calling the dedicate Polybar functions
    "--polybar-display") polybar_display ;;
    "--polybar-click-left") polybar_click_left ;;
    *) echo -e "$MESSAGE_ERROR" ;;
esac