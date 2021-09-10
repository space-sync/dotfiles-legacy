#!/usr/bin/env sh

#############################
#Global variables
#############################

#_TERMINAL="gnome-terminal --hide-menubar -x"
#_TERMINAL="urxvt -e"
_TERMINAL="alacritty -e"

#_MY_DOTFILES="$HOME/.config/my_dotfiles"
_MY_DOTFILES="/usr/share/lord"
#/usr/share/lord/dotfiles/i3/temp

#############################
#Functions
#############################

clean_directory(){
    rm $HOME/.config/my_dotfiles/i3/temp/*
}

screenshot(){
    scrot -q 50 "$_MY_DOTFILES/i3/temp/screenshot.png"
}

blur_image(){
    convert "$_MY_DOTFILES/i3/temp/screenshot.png" -blur '0x9' "$_MY_DOTFILES/i3/temp/lock_screen.png"
}

opening_matrix(){
    #Opening the terminal
    #$_TERMINAL matrix &

    #$_TERMINAL unimatrix -ns 95 &
    #$_TERMINAL unimatrix -s 95 -l nkp &
    $_TERMINAL unimatrix -s 95 -l kp &

    #Setting the delay
    sleep 0.7

    #Move the Matrix effect to i3 workspace
    i3-msg move container to workspace number 0
    
    #Go to i3 workspace 0
    i3-msg workspace 0

    #Setting the terminal to fullscreen mode
    i3-msg fullscreen toggle
}

lock_operating_system_matrix(){
    opening_matrix
    i3lock -fn; i3-msg kill
}

lock_operating_system_blurred_screenshot(){
    i3-msg workspace 0
    screenshot
    blur_image
    i3lock -fi $_MY_DOTFILES/i3/temp/lock_screen.png;
    wait_until_get_unlocked
}

lock_operating_system_picture(){
    i3-msg workspace 0
    i3lock -fi $_MY_DOTFILES/dotfiles/neofetch/harpyShark.png;
    wait_until_get_unlocked
}

lock_operating_system_lord(){
    opening_matrix
    #i3lock -fi $_MY_DOTFILES/dotfiles/neofetch/harpyShark.png; kill
    i3lock -fi $_MY_DOTFILES/dotfiles/Lock screen.png; kill
    wait_until_get_unlocked
}

wait_until_get_unlocked(){
    while [  "$(pgrep -x i3lock)" ]; do
        #Do nothing beyond expanding arguments and performing redirections.
        :
    done
}

unlock_notification(){
    #Go back to the last i3 workspace
    i3-msg workspace back_and_forth

    #Sending a mensage right after the operating system gets unlocked
    _NAME=$(finger $USER | grep Name | awk -F '\t\tName: ' '{print $2}')
    notify-send "Welcome back, $_NAME" &
}

#############################
#Callers
#############################

clean_directory

#SELECT THE ONE TO BE EXECUTED
lock_operating_system_matrix
#lock_operating_system_blurred_screenshot
#lock_operating_system_picture
#lock_operating_system_lord

unlock_notification

#Testing
#bindsym $COMMAND + $SHIFT + E exec "i3-nagbar -t warning -m 'Ahh!!! You have pressed the exit shortcut. Do you really want to exit from the custom i3? This will end your session.' -B 'Yes, exit i3' 'i3-msg exit'"

#"i3-nagbar -t warning -m 'Ahh!!! You have pressed the exit shortcut. Do you really want to exit from the custom i3? This will end your session.' -B 'Yes, exit i3' 'i3-msg exit'"

#i3-msg exec "i3-nagbar -t warning -m 'THIS IS A TEST.' -B 'Yes, exit i3'"

#i3-nagbar -m 'You have an error in your i3 config file!' -b 'edit config' 'i3-sensible-editor ~/.config/i3/config'
