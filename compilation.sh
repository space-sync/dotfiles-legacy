#!/usr/bin/env sh

#############################
#Declaring variables
#############################

AUX1=$1
AUX2=$2

#Absolute path where this file script is storaged
PATH_SCRIPT="$(dirname "$(readlink -f "$0")")"
PATH_SCRIPT_OUTPUT="$PATH_SCRIPT/compiled"

#Absolute path where the fonts are storaged
#PATH_FONTS_ROOT="/usr/local/share/fonts"
#PATH_FONTS_USER="$HOME/.fonts"

_MY_DOTFILES_DIRECTORY="$PATH_SCRIPT/src"

#My dotfiles directory global files
_HEADER="$_MY_DOTFILES_DIRECTORY/global/00_Header.md"
_MANUAL="$_MY_DOTFILES_DIRECTORY/global/01_Manual.md"
_DEFINITION="$_MY_DOTFILES_DIRECTORY/global/02_Definition.md"
_LICENSE="$_MY_DOTFILES_DIRECTORY/global/03_License.md"

#System configuration files
_ALACRITTY="$PATH_SCRIPT_OUTPUT/alacritty.yml"
_ALBERT="$PATH_SCRIPT_OUTPUT/albert.conf"
_BASHRC="$PATH_SCRIPT_OUTPUT/.bashrc"
_CAVA="$PATH_SCRIPT_OUTPUT/cava.conf"
_COMPTON="$PATH_SCRIPT_OUTPUT/compton.conf"
_DOLPHIN="$PATH_SCRIPT_OUTPUT/dolphinrc"
_DUNST="$PATH_SCRIPT_OUTPUT/dunstrc"
_FUSUMA="$PATH_SCRIPT_OUTPUT/fusuma.yml"
_HTOP="$PATH_SCRIPT_OUTPUT/htoprc"
_i3="$PATH_SCRIPT_OUTPUT/i3.conf"
_LYRICS_IN_TERMINAL="$PATH_SCRIPT_OUTPUT/lyrics-in-terminal.cfg"
_NEOFETCH="$PATH_SCRIPT_OUTPUT/neofetch.conf"
_PICOM="$PATH_SCRIPT_OUTPUT/picom.conf"
_POLYBAR="$PATH_SCRIPT_OUTPUT/polybar.conf"

#_RANGER="$HOME/.config/ranger/"
#_RANGER_COLOR_SCHEME="$HOME/.config/ranger/colorschemes/theme.py"
#_RANGER_RC="$HOME/.config/ranger/rc.conf"
#_RANGER_RIFLE="$HOME/.config/ranger/rifle.conf"
#_ROFI="$HOME/.config/rofi/"

_SXHKD="$PATH_SCRIPT_OUTPUT/sxhkdrc"
_URXVT="$PATH_SCRIPT_OUTPUT/.Xresources_urxvt"
_VIM="$PATH_SCRIPT_OUTPUT/.vimrc"

_VISUAL_STUDIO_CODE_KEYBINDINGS="$PATH_SCRIPT_OUTPUT/visual_studio_code_keybindings.json"
_VISUAL_STUDIO_CODE_SETTINGS="$PATH_SCRIPT_OUTPUT/visual_studio_code_settings.json"

#_VLC="$HOME/.config/vlc/vlcrc"
#_VLC_PLUGIN="$HOME/.local/share/vlc"
#_XFCE4_PANEL="$HOME/.config/xfce4"

_XTERM="$PATH_SCRIPT_OUTPUT/.Xresources_xterm"
_YAD="$PATH_SCRIPT_OUTPUT/yad.conf"
#cat $_MY_DOTFILES_DIRECTORY/yad/*.conf >> $_YAD
_ZSHRC="$PATH_SCRIPT_OUTPUT/.zshrc"

MESSAGE_HELP="
\t\t\tDotfiles compilation
\t\t\t--------------------\n
[Description]

[Parameters]
-h\t\t--help\t-?\t\t\tDisplay this help message
-e\t\t--edit\t\t\t\tEdit this script file
-c-all\t\t--compile-all\t\t\tCompile all dotfiles at once
-c-alacritty\t--compile-alacritty\t\tCompile ??? dotfiles
-c-albert\t--compile-albert\t\tCompile ??? dotfiles
-c-bash\t\t--compile-bash\t\t\tCompile ??? dotfiles
-c-cava\t\t--compile-cava\t\t\tCompile ??? dotfiles
-c-comptom\t--compile-comptom\t\tCompile ??? dotfiles
-c-dolphin\t--compile-dolphin\t\tCompile ??? dotfiles
-c-dunst\t--compile-dunst\t\t\tCompile ??? dotfiles
-c-feh\t\t--compile-feh\t\t\tCompile ??? dotfiles (NOT IMPLEMENTED YED)
-c-fusuma\t--compile-fusuma\t\tCompile ??? dotfiles
-c-htop\t\t--compile-htop\t\t\tCompile ??? dotfiles
-c-i3\t\t--compile-i3\t\t\tCompile ??? dotfiles
-c-lit\t\t--compile-lyrics-in-terminal\tCompile ??? dotfiles
-c-neofetch\t--compile-neofetch\t\tCompile ??? dotfiles
-c-picom\t--compile-picom\t\t\tCompile ??? dotfiles
-c-polybar\t--compile-polybar\t\tCompile ??? dotfiles
-c-ranger\t--compile-ranger\t\tCompile ??? dotfiles (NOT IMPLEMENTED YED)
-c-rofi\t\t--compile-rofi\t\t\tCompile ??? dotfiles (NOT IMPLEMENTED YED)
-c-sxhkd\t--compile-sxhkd\t\t\tCompile ??? dotfiles
-c-vscode\t--compile-visual-studio-code\tCompile ??? dotfiles
-c-urxvt\t--compile-urxvt\t\t\tCompile ??? dotfiles
-c-vim\t\t--compile-vim\t\t\tCompile ??? dotfiles
-c-vlc\t\t--compile-vlc\t\t\tCompile ??? dotfiles
-c-xfce4\t--compile-xfce4-panel\t\tCompile ??? dotfiles (NOT IMPLEMENTED YED)
-c-xterm\t--compile-xterm\t\t\tCompile ??? dotfiles (NOT IMPLEMENTED YED)
-c-yad\t\t--compile-yad\t\t\tCompile ??? dotfiles
-c-zsh\t\t--compile-zsh\t\t\tCompile ??? dotfiles
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_ERROR"

#############################
#Functions
#############################

display_message(){
	echo -e "#############################\n#$1\n#############################"
}

tools_clear_file(){
	cat /dev/null > $1
}

tools_create_folder(){
	mkdir -p $1
}

tools_apply_header(){
	cat $_HEADER >> $1
}

tools_apply_manual(){
	cat $_MANUAL >> $1
}

tools_replace_variables(){
	local FILENAME=$(cat $1)
	local STRING_OLD=$2
	local STRING_NEW=$3 #"/home/joker/.dotfiles"

	#Replacing all strings matches occurrences in a file using ${parameter//pattern/string}
	echo "${FILENAME//$STRING_OLD/$STRING_NEW}" > $1
}

#MUST BE TESTED
generate_alacritty(){
	display_message "Compiling Alacritty dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_ALACRITTY
	tools_apply_header $_ALACRITTY
	tools_apply_manual $_ALACRITTY
    cat $_MY_DOTFILES_DIRECTORY/alacritty/*.yml >> $_ALACRITTY
}

generate_albert(){
	display_message "Compiling Albert dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_ALBERT
	tools_apply_header $_ALBERT
	tools_apply_manual $_ALBERT
    cat $_MY_DOTFILES_DIRECTORY/albert/*.conf >> $_ALBERT
}

generate_bash(){
	display_message "Compiling BashRC dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_BASHRC
	tools_apply_header $_BASHRC
	tools_apply_manual $_BASHRC
    cat $_MY_DOTFILES_DIRECTORY/bash/*.conf >> $_BASHRC
}

generate_cava(){
	display_message "Compiling Cava dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_CAVA
	tools_apply_header $_CAVA
	tools_apply_manual $_CAVA
    cat $_MY_DOTFILES_DIRECTORY/cava/*.conf >> $_CAVA
}

generate_compton(){
	display_message "Compiling Compton dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_COMPTON
	tools_apply_header $_COMPTON
	tools_apply_manual $_COMPTON
    cat $_MY_DOTFILES_DIRECTORY/compton/*.conf >> $_COMPTON
}

generate_dolphin(){
	display_message "Compiling Dolphin dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_DOLPHIN
	tools_apply_header $_DOLPHIN
	tools_apply_manual $_DOLPHIN
    cat $_MY_DOTFILES_DIRECTORY/dolphin/*.conf >> $_DOLPHIN
}

generate_dunst(){
	display_message "Compiling Dunst dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_DUNST
	tools_apply_header $_DUNST
	tools_apply_manual $_DUNST
    cat $_MY_DOTFILES_DIRECTORY/dunst/*.conf >> $_DUNST
}

#FEH

generate_fusuma(){
	display_message "Compiling Fusuma dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_FUSUMA
	tools_apply_header $_FUSUMA
	tools_apply_manual $_FUSUMA
    cat $_MY_DOTFILES_DIRECTORY/fusuma/*.yml >> $_FUSUMA
}

generate_htop(){
	display_message "Compiling HTop dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_HTOP
	tools_apply_header $_HTOP
	tools_apply_manual $_HTOP
    cat $_MY_DOTFILES_DIRECTORY/htop/*.conf >> $_HTOP
}

generate_i3(){
	display_message "Compiling i3 dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_i3
	tools_apply_header $_i3
	tools_apply_manual $_i3
    cat $_MY_DOTFILES_DIRECTORY/i3/*/*.conf >> $_i3
	tools_replace_variables $_i3 "\$DOTFILES" "$PATH_SCRIPT"
}

generate_lyrics_in_terminal(){
	display_message "Compiling Lyrics-in-terminal dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_LYRICS_IN_TERMINAL
	tools_apply_header $_LYRICS_IN_TERMINAL
	tools_apply_manual $_LYRICS_IN_TERMINAL
    cat $_MY_DOTFILES_DIRECTORY/lyrics_in_terminal/*.conf >> $_LYRICS_IN_TERMINAL
}

generate_neofetch(){
	display_message "Compiling Neofetch dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_NEOFETCH
	tools_apply_header $_NEOFETCH
	tools_apply_manual $_NEOFETCH
    cat $_MY_DOTFILES_DIRECTORY/neofetch/*.conf >> $_NEOFETCH
}

generate_picom(){
	display_message "Compiling Picom dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_PICOM
	tools_apply_header $_PICOM
	tools_apply_manual $_PICOM
    cat $_MY_DOTFILES_DIRECTORY/picom/*.conf >> $_PICOM
}

generate_polybar(){
	display_message "Compiling Polybar dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_POLYBAR
	tools_apply_header $_POLYBAR
	tools_apply_manual $_POLYBAR
    cat $_MY_DOTFILES_DIRECTORY/polybar/*/*.conf >> $_POLYBAR
}

#RANGER
#ROFI

generate_sxhkd(){
	display_message "Compiling SXHKD dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_SXHKD
	tools_apply_header $_SXHKD
	tools_apply_manual $_SXHKD
    cat $_MY_DOTFILES_DIRECTORY/sxhkd/*.conf >> $_SXHKD
}

generate_visual_studio_code(){
	display_message "Compiling Visual Studio Code dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/

    #Keybindings
	tools_clear_file $_VISUAL_STUDIO_CODE_KEYBINDINGS
	#tools_apply_header $_VISUAL_STUDIO_CODE_KEYBINDINGS
	#tools_apply_manual $_VISUAL_STUDIO_CODE_KEYBINDINGS
    cat $_MY_DOTFILES_DIRECTORY/visual_studio_code/keybindings/*.json >> $_VISUAL_STUDIO_CODE_KEYBINDINGS

    #Settings
	tools_clear_file $_VISUAL_STUDIO_CODE_SETTINGS
	#tools_apply_header $_VISUAL_STUDIO_CODE_SETTINGS
	#tools_apply_manual $_VISUAL_STUDIO_CODE_SETTINGS
    cat $_MY_DOTFILES_DIRECTORY/visual_studio_code/settings/*.json >> $_VISUAL_STUDIO_CODE_SETTINGS
}

generate_urxvt(){
	display_message "Compiling URXVT dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_URXVT
	tools_apply_header $_URXVT
	tools_apply_manual $_URXVT
    cat $_MY_DOTFILES_DIRECTORY/urxvt/*.conf >> $_URXVT
}

generate_vim(){
	display_message "Compiling Vim dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_VIM
	tools_apply_header $_VIM
	tools_apply_manual $_VIM
    cat $_MY_DOTFILES_DIRECTORY/vim/*.conf >> $_VIM
}

#VLC
#XFCE4_PANEL

generate_xterm(){
	display_message "Compiling X-Term dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_XTERM
	tools_apply_header $_TERM
	tools_apply_manual $_TERM
    cat $_MY_DOTFILES_DIRECTORY/xterm/*.conf >> $_XTERM
}

generate_yad(){
	display_message "Compiling Yad dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_YAD
	tools_apply_header $_YAD
	tools_apply_manual $_YAD
    cat $_MY_DOTFILES_DIRECTORY/yad/*.conf >> $_YAD
}

generate_zsh(){
	display_message "Compiling ZshRC dotfile..."
	tools_create_folder $PATH_SCRIPT_OUTPUT/
	tools_clear_file $_ZSHRC
	tools_apply_header $_ZSHRC
	tools_apply_manual $_ZSHRC
    cat $_MY_DOTFILES_DIRECTORY/zsh/*.conf >> $_ZSHRC
}

compile_all(){
	generate_albert
	generate_bash
	generate_cava
	generate_compton
	generate_dolphin
	generate_dunst
	#generate_feh
	generate_fusuma
	generate_htop
	generate_i3
	generate_lyrics_in_terminal
	generate_neofetch
	generate_picom
	generate_polybar
	#generate_ranger
	#generate_rofi
	generate_sxhkd
	generate_visual_studio_code
	generate_urxvt
	generate_vim
	#generate_vlc
	#generate_xfce4_panel
	generate_xterm
	generate_yad
	generate_zsh
}

#############################
#Calling the functions
#############################

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;;
	"-c-all" | "--compile-all") compile_all ;;
	"-c-alacritty" | "--compile-alacritty") generate_alacritty ;;

	#"-c-" | "--compile-") generate_ ;;
	#"-c-" | "--compile-") generate_ ;;
	#"-c-" | "--compile-") generate_ ;;
	#"-c-" | "--compile-") generate_ ;;
	#"-c-" | "--compile-") generate_ ;;
	#"-c-" | "--compile-") generate_ ;;

	"-c-albert" | "--compile-albert") generate_albert ;;
	"-c-bash" | "--compile-bash") generate_bash ;;
	"-c-cava" | "--compile-cava") generate_cava ;;
	"-c-compton" | "--compile-compton") generate_compton ;;
	"-c-dolphin" | "--compile-dolphin") generate_dolphin ;;
	"-c-dunst" | "--compile-dunst") generate_dunst ;;
	#"-c-feh" | "--compile-feh") generate_feh ;;
	"-c-fusuma" | "--compile-fusuma") generate_fusuma ;;
	"-c-htop" | "--compile-htop") generate_htop ;;
	"-c-i3" | "--compile-i3") generate_i3 ;;
	"-c-lit" | "--compile-lyrics-in-terminal") generate_lyrics_in_terminal ;;
	"-c-neofetch" | "--compile-neofetch") generate_neofetch ;;
	"-c-picom" | "--compile-picom") generate_picom ;;
	"-c-polybar" | "--compile-polybar") generate_polybar ;;
	#"-c-ranger" | "--compile-ranger") generate_ranger ;;
	#"-c-rofi" | "--compile-rofi") generate_rofi ;;
	"-c-sxhkd" | "--compile-sxhkd") generate_sxhkd ;;
	"-c-vscode" | "--compile-visual-studio-code") generate_visual_studio_code ;;
	"-c-urxvt" | "--compile-urxvt") generate_urxvt ;;
	"-c-vim" | "--compile-vim") generate_vim ;;
	#"-c-vlc" | "--compile-vlc") generate_vlc ;;
	#"-c-xfce4" | "--compile-xfce4-panel") generate_xfce4_panel ;;
	"-c-xterm" | "--compile-xterm") generate_xterm ;;
	"-c-yad" | "--compile-yad") generate_yad ;;
	"-c-zsh" | "--compile-zsh") generate_zsh ;;
	*) echo -e "$MESSGE_ERROR" ;;
esac
