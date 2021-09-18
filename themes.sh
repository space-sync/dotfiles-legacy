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

visual_studio_code_extension(){
	echo "Must be implemented"
}

#############################
#Calling the functions
#############################

gtk_dracula_theme
gtk_dracula_icons
#eclipse_dracula_theme
#netbeans_dracula_theme
#visual_studio_code_extension
