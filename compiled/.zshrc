#=================================================================
#                         Dotfile manager
# Date creation : 14/10/2020
# Date current  : 06/09/2021
# Version       : v0.1.2
# Author        : Henrik Beck at https://github.com/henrikbeck95/
# Project       : https://github.com/henrikbeck95/dotfiles/
#=================================================================

#############################################################################
#READ THIS QUICK TUTORIAL FOR NOT BREAKING THE OPERATION SYSTEM DOWN AND CRY
#############################################################################

# WARNING!
#DO NOT EDIT THIS CONFIGURATION FILE FROM HERE. THERE IS A SHELL SCRIPT FILE CALLED "generate.sh" THAT WAS MADE TO PROVIDE MORE COMFORTABLE AND ORGANIZABLE FOR MANAGEMENTING THE DOTFILES.

#THE SETTINGS FILES ARE SPLITED INTO MODULES WHAT MINIMIZES THE RISK TO BREAK THE SOFTWARES SETTINGS DOWN. FURTHERMORE IT ALSO PREVENTS THE SAME OLD SYNTAX THAT WE ARE USED TO USE IN ALL THESE CONFIGURATION FILES.

#FOR MORE INFORMATIONS ABOUT HOW IT WORKS TAKE A LOOK AT THE **DOTFILES** OFFICIAL REPOSITORY.

#███████╗███████╗██╗  ██╗
#╚══███╔╝██╔════╝██║  ██║
#  ███╔╝ ███████╗███████║
# ███╔╝  ╚════██║██╔══██║
#███████╗███████║██║  ██║
#╚══════╝╚══════╝╚═╝  ╚═╝

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/$USER/.oh-my-zsh"
#export ZSH="/root/.oh-my-zsh"

export PATH=$PATH:$HOME/development/flutter/bin
export PATH=$PATH:$HOME/development/flutter/bin/cache/dart-sdk/bin

export SDKMANAGER_OPTS="--add-modules java.se.ee"

#Testing
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64/bin/java"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME

#Themes
## See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="henrik"
##ZSH_THEME="3den"
##ZSH_THEME="Solidah"
##ZSH_THEME="abden"
##ZSH_THEME="af-magic"
##ZSH_THEME="aflower"
##ZSH_THEME="agnoster"
##ZSH_THEME="alanpeabody"
##ZSH_THEME="amuse'"
##ZSH_THEME="apple"
##ZSH_THEME="arrow"
##ZSH_THEME="aussiegeek"
##ZSH_THEME="avit"
##ZSH_THEME="awesomepanda"
##ZSH_THEME="bira"
##ZSH_THEME="blinks"
##ZSH_THEME="bureau"
##ZSH_THEME="candy-kingdom"
##ZSH_THEME="candy"
##ZSH_THEME=clean""
##ZSH_THEME="cloud"
##ZSH_THEME="crcandy"
##ZSH_THEME="crunch"
##ZSH_THEME="cypher"
##ZSH_THEME="dallas"
##ZSH_THEME="darkblood"
##ZSH_THEME="daveverwer"
##ZSH_THEME="dieter"
##ZSH_THEME="dogenpunk"
##ZSH_THEME="dpoggi"
##ZSH_THEME="dst"
##ZSH_THEME="dstufft"
##ZSH_THEME="duellj"
##ZSH_THEME="eastwood"
##ZSH_THEME="edvardm"
##ZSH_THEME="emotty"
##ZSH_THEME="essembeh"
##ZSH_THEME="evan"
##ZSH_THEME="fino-time"
##ZSH_THEME="fino"
##ZSH_THEME="fishy"
##ZSH_THEME="flazz"
##ZSH_THEME="fletcherm"
##ZSH_THEME="fox"
##ZSH_THEME="frisk"
##ZSH_THEME="frontcube"
##ZSH_THEME="funky"
##ZSH_THEME="fwalch"
##ZSH_THEME="gallifrey"
##ZSH_THEME="gallois"
##ZSH_THEME="garyblessington"
##ZSH_THEME="gentoo"
##ZSH_THEME="geoffgarside"
##ZSH_THEME="gianu"
##ZSH_THEME="gnzh"
##ZSH_THEME="gozilla"
##ZSH_THEME="half-life"

##ZSH_THEME="henrik"

##ZSH_THEME="humza"
##ZSH_THEME="imajes"
##ZSH_THEME="intheloop"
##ZSH_THEME="itchy"
##ZSH_THEME="jaischeema"
##ZSH_THEME="jbergantine"
##ZSH_THEME="jispwoso"
##ZSH_THEME="jnrowe"
##ZSH_THEME="jonathan"
##ZSH_THEME="josh"
##ZSH_THEME="jreese"
##ZSH_THEME="jtriley"
##ZSH_THEME="juanghurtado"
##ZSH_THEME="junkfood"
##ZSH_THEME="kafeitu"
##ZSH_THEME="kardan"
##ZSH_THEME="kennethreitz"
##ZSH_THEME="kiwi"
##ZSH_THEME="kolo"
##ZSH_THEME="kphoen"
##ZSH_THEME="lambda"
##ZSH_THEME="linuxonly"
##ZSH_THEME="lukerandall"
##ZSH_THEME="macovsky-ruby"
##ZSH_THEME="macovsky"
##ZSH_THEME="maran"
##ZSH_THEME="mgutz"
##ZSH_THEME="mh"
##ZSH_THEME="michelebologna"
##ZSH_THEME="mikeh"
##ZSH_THEME="miloshadzic"
##ZSH_THEME="minimal"
##ZSH_THEME="mira"
##ZSH_THEME="mlh"
##ZSH_THEME="mortalscumbag"
##ZSH_THEME="mrtazz"
##ZSH_THEME="murilasso"
##ZSH_THEME="muse"
##ZSH_THEME="nanotech"
##ZSH_THEME="nebirhos"
##ZSH_THEME="nicoulaj"
##ZSH_THEME="norm"
##ZSH_THEME="obraun"
##ZSH_THEME="peepcode"
##ZSH_THEME="phillips"
##ZSH_THEME="pmcgee"
##ZSH_THEME="pygmalion-virtalenv"
##ZSH_THEME="pygmalion"
##ZSH_THEME="random"
##ZSH_THEME="re5et"
##ZSH_THEME="refined"
##ZSH_THEME="rgm"
##ZSH_THEME="risto"
##ZSH_THEME="rixius"
##ZSH_THEME="rkj-repos"
##ZSH_THEME="rkj"
##ZSH_THEME="robbyrussel"
##ZSH_THEME="sammy"
##ZSH_THEME="simonoff"
##ZSH_THEME="simple"
##ZSH_THEME="skaro"
##ZSH_THEME="smt"
##ZSH_THEME="soniccradish"
##ZSH_THEME="sorin"
##ZSH_THEME="sporty"
##ZSH_THEME="steeef"
##ZSH_THEME="strug"
##ZSH_THEME="sunaku"
##ZSH_THEME="sunrise"
##ZSH_THEME="superjarin"
##ZSH_THEME="suvash"
##ZSH_THEME="takashiyoshida"
##ZSH_THEME="terminalparty"
##ZSH_THEME="theunraveler"
##ZSH_THEME="tjkirch_mod"
##ZSH_THEME="tonotdo"
##ZSH_THEME="trapd00r"
##ZSH_THEME="wedisagree"
##ZSH_THEME="wezm+"
##ZSH_THEME="wezm"
##ZSH_THEME="wuffers"
##ZSH_THEME="xiong-chiamiov-plus"
##ZSH_THEME="xiong-chiamiov"
##ZSH_THEME="ys"
##ZSH_THEME="zhann"



# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/

# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=("robbyrussell" "agnoster")

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

