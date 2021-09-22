#!/usr/bin/env sh

#############################
#Declaring variables
#############################

PATH_ICONS_ROOT="/usr/share/icons"
PATH_ICONS_USER="$HOME/.icons"

PATH_THEMES_ROOT="/usr/share/themes"
PATH_THEMES_USER="$HOME/.themes"

#############################
#Functions
#############################

display_message(){
	echo -e "$1"
}

tools_verify_root_previledges(){
	if [[ $UID == 0 ]]; then
		PATH_ICONS="$PATH_ICONS_ROOT"
		PATH_THEMES="$PATH_THEMES_ROOT"
	else
		PATH_ICONS="$PATH_ICONS_USER"
		PATH_THEMES="$PATH_THEMES_USER"
	fi
}

gtk_dracula_icons(){
	tools_verify_root_previledges
	mkdir -p $PATH_ICONS/
	local GTK_ICON_DRACULA_FILENAME="/tmp/gtk_icon_dracula.zip"

	#Download using the GitHub .zip
	wget https://github.com/dracula/gtk/files/5214870/Dracula.zip -O $GTK_ICON_DRACULA_FILENAME

	#Extract the .zip file to the icons directory
	unzip $GTK_ICON_DRACULA_FILENAME -d $PATH_ICONS/

	#Activating icons
	gsettings set org.gnome.desktop.interface icon-theme "Dracula"

	#Remove .zip file
	rm -f $GTK_ICON_DRACULA_FILENAME
}

gtk_dracula_theme(){
	tools_verify_root_previledges
	mkdir -p $PATH_THEMES/
	local GTK_THEME_DRACULA_FILENAME="/tmp/gtk_theme_dracula.zip"

	#Download using the GitHub .zip
	wget https://github.com/dracula/gtk/archive/master.zip -O $GTK_THEME_DRACULA_FILENAME

	#Extract the .zip file to the themes directory
	unzip $GTK_THEME_DRACULA_FILENAME -d $PATH_THEMES/

	#Activating theme
	gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
	gsettings set org.gnome.desktop.wm.preferences theme "Dracula"

	#Remove .zip file
	rm -f $GTK_THEME_DRACULA_FILENAME
}

eclipse_dracula_theme(){
	echo "Must be implemented"
}

netbeans_dracula_theme(){
	echo "Must be implemented"
}

#MUST BE TESTED
visual_studio_code_extension(){
	#Normal/Snap installation
	#local VISUAL_STUDIO_CODE="code"
	local VISUAL_STUDIO_CODE="codium"

	#TESTING
	#local VISUAL_STUDIO_CODE="$HOME/sharing/stuffs/softwares/linux/appimages/VSCodium-1.60.0-1630974030.glibc2.17-x86_64.AppImage code"
	#local VISUAL_STUDIO_CODE="$HOME/sharing/stuffs/softwares/linux/appimages/VSCodium-1.60.0-1630974030.glibc2.17-x86_64.AppImage codium"

	#Flatpak installation
	#local VISUAL_STUDIO_CODE="flatpak run com.visualstudio.code"
	#local VISUAL_STUDIO_CODE="flatpak run com.vscodium.codium"

	local VISUAL_STUDIO_CODE_EXTENSION_INSTALL="$VISUAL_STUDIO_CODE --install-extension"
	local VISUAL_STUDIO_CODE_EXTENSION_LIST="$VISUAL_STUDIO_CODE --list-extensions"

    display_message "Visual Studio Code/Codium installing extensions..."

    ############################
    #Midnight City night theme
    #############################

    #$VISUAL_STUDIO_CODE_EXTENSION_INSTALL ${BASH_SOURCE%/*}/dillonchanis.midnight-city-0.6.0.vsix
    #$VISUAL_STUDIO_CODE_EXTENSION_INSTALL /tmp/dillonchanis.midnight-city-0.6.0.vsix
    $VISUAL_STUDIO_CODE_EXTENSION_INSTALL $HOME/.dotfiles/extensions/midnight-city-0.6.0_vsixhub.com.vsix
    
    #############################
    #WORKED
    #############################
    
    $VISUAL_STUDIO_CODE_EXTENSION_INSTALL streetsidesoftware.code-spell-checker #Code Spell Checker
    $VISUAL_STUDIO_CODE_EXTENSION_INSTALL formulahendry.code-runner #Code Runner
    $VISUAL_STUDIO_CODE_EXTENSION_INSTALL dart-code.dart-code #Dart language
    $VISUAL_STUDIO_CODE_EXTENSION_INSTALL ms-azuretools.vscode-docker #Docker
    $VISUAL_STUDIO_CODE_EXTENSION_INSTALL dracula-theme.theme-dracula #Dracula night Theme
    $VISUAL_STUDIO_CODE_EXTENSION_INSTALL dart-code.flutter #Flutter framework
    $VISUAL_STUDIO_CODE_EXTENSION_INSTALL github.github-vscode-theme #GitHub light theme
    $VISUAL_STUDIO_CODE_EXTENSION_INSTALL bierner.markdown-preview-github-styles #Markdown Preview Github Styling
    $VISUAL_STUDIO_CODE_EXTENSION_INSTALL pkief.material-icon-theme #Material Icon theme to folders
    
    #############################
    #NOT WORKED
    #############################

    ##$VISUAL_STUDIO_CODE alefragnani.bookmarks #Bookmarks
    #$VISUAL_STUDIO_CODE_EXTENSION_INSTALL ms-vscode.cpptools #C/C++
    #$VISUAL_STUDIO_CODE_EXTENSION_INSTALL bierner.markdown-checkbox #Markdown Checkboxes
    #$VISUAL_STUDIO_CODE_EXTENSION_INSTALL ms-python.python #Python language
    #$VISUAL_STUDIO_CODE_EXTENSION_INSTALL 2gua.rainbow-brackets #Rainbow Brackets
    ##$VISUAL_STUDIO_CODE_EXTENSION_INSTALL vscodevim.vim #Vim mode
    #$VISUAL_STUDIO_CODE_EXTENSION_INSTALL jevakallio.vscode-hacker-typer #VSCode HackerTyper record typing
}

#############################
#Calling the functions
#############################

#gtk_dracula_theme
#gtk_dracula_icons

#eclipse_dracula_theme
#netbeans_dracula_theme
visual_studio_code_extension
