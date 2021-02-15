export ZSH="/home/lonyelon/.oh-my-zsh"

ZSH_THEME="af-magic"

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_UPDATE_PROMPT="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(git)

source $ZSH/oh-my-zsh.sh

# export MANPATH="/usr/local/man:$MANPATH"

export LANG=es_ES.UTF-8
export EDITOR='nvim'
export BROWSER='librewolf'
# export ARCHFLAGS="-arch x86_64"

# Include aliases
source .aliases

neofetch

[ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ] && startx
