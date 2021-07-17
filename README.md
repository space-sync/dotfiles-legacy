# Dotfiles

Configure once and use it anywhere.

## Description

_Dotfiles_ are plain text configuration files used by the softwares for loading their settings. It is very useful for the users avoiding to configure their settings preferences again every single time the software gets installed.

The name _dotfile_ has it name because most of these kind of files starts with **.** followed by the file name and tipically making these files to be hidden on the operating system file manager. For example: **.bashrc**, **.profile**, **.vimrc** and so.

If you backup the **dotfile** and restore it on your new environment you are up to use all the settings once you had set.

The **Dotfile** project is a package manager for the _dotfiles_ to make all this process easier. By default it applies some settings carefully choosen to improve the softwares experience such as functionalities and themes.

Be sure you have already installed the softwares before applying the settings.

## Installation setup

### Dependencies

1. cURL
1. Git

### Installation

- Install **Dotfiles** on your system
	> $ `curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/henrikbeck95/dotfiles/main/install.sh | sh`
