# Dotfiles

Configure once and use it anywhere.

## Description

**Dotfiles** are plain text configuration files used by the softwares for loading their settings. It is very useful for the users avoiding to configure their settings preferences again every single time the software gets installed.

The **Dotfile** therm has it name because most of these kind of files starts with `.` followed by the file name and tipically making these files to be hidden on the operating system file manager. For example: `.bashrc`, `.profile`, `.vimrc` and so on.

If you backup the **Dotfile** and restore it on your new environment you are up to use all the settings once you had set.

The **Dotfile** project is a package manager for the _dotfiles_ to make all this setup process easier. By default it applies some settings carefully choosen to improve the softwares experience such as functionalities and themes.

Be sure you have already installed the softwares before applying the settings.

## Setup

### Supported softwares

1. [~] Alacritty
1. [~] Bash
1. [~] Feh
1. [~] HTop
1. [~] LF
1. [~] Sxhkd
1. [~] X-Term

- Studying
1. [ ] Discord
1. [ ] Firefox
1. [ ] QuteBrowser
1. [ ] GRUB
1. [ ] Wallpaper
#OH_MY_BASH
#OH_MY_POSH
#OH_MY_ZSH

- Plugins and extensions
1. [ ] NeoVIM
1. [~] Tmux
1. [ ] TPM
1. [~] Vim
1. [ ] Visual Studio Code
1. [ ] Visual Studio Codium
1. [ ] Vundle
1. [ ] Zellij

- Non color theme
	1. [ ] Git
	1. [ ] Htop
	1. [ ] MPV
	1. [ ] Nano
	1. [ ] Image Magick
	1. [ ] OBS-Studio
	1. [ ] Picom
	1. [ ] Redshift
	1. [ ] Task Warrior
	1. [ ] VLC

- Color theme
	1. [ ] ~Adobe~
	1. [ ] Albert
	1. [ ] Alfred
	1. [ ] Audacity
	1. [ ] Blender
	1. [ ] DMenu
	1. [ ] Dunst
	1. [ ] Eclipse
	1. [ ] Figma
	1. [ ] FZF
	1. [ ] Gedit
	1. [ ] Ghost writer
	1. [ ] Git Kraken
	1. [ ] Gnome terminal
	1. [ ] i3
	1. [ ] Inkscape
	1. [ ] Insomnia
	1. [ ] Javadoc
	1. [ ] Joplin
	1. [ ] Kate
	1. [ ] Kitty
	1. [ ] Konsole
	1. [ ] Konsole
	1. [ ] Krita
	1. [ ] Latex
	1. [ ] LibreOffice
	1. [ ] MailSpring
	1. [ ] Midnight Commander
	1. [ ] MindNode
	1. [ ] Mousepad
	1. [ ] Mutt
	1. [ ] NetBeans
	1. [ ] Node console
	1. [ ] Pandoc
	1. [ ] Polybar
	1. [ ] QBitTorrent
	1. [ ] QT5
	1. [ ] Rofi
	1. [ ] Steam
	1. [ ] Sublime Text 3
	1. [ ] ThunderBird
	1. [ ] ULauncher
	1. [ ] XFCE4 Terminal
	1. [ ] Xournal++
	1. [ ] XResources
	1. [ ] Zathura

### Dependencies

1. [x] cURL
1. [x] Git
1. [x] Linux

### Installation

The procedure below must be executed with **root** previleges:

- Install **Dotfiles** on your system
	> $ `curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/henrikbeck95/dotfiles/main/install.sh | sh`

### Uninstallation

By default the _uninstalling **Dotfiles** process_ from your system **does not** remove all the dotfiles. If you want to remove all the dotfiles use $ `dotfile --remove-all` command before uninstalling **Dotfiles**.

The procedure below must be executed with **root** previleges:

- Uninstall **Dotfiles** on your system
	> $ `curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/henrikbeck95/dotfiles/main/uninstall.sh | sh`