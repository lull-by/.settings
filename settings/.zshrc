# Path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="steeef"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Disable marking untracked files under VCS as dirty.
# Makes repository status check for large repositories faster
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Command execution time in history command
HIST_STAMPS="yyyy-mm-dd"

# Plugins
# ------------------------------------------------------------------------------
# Standard plugins in $ZSH/plugins/
# Custom plugins in $ZSH_CUSTOM/plugins/
# Too many plugins slow down shell startup.

plugins=(
  git
  colored-man-pages  
)

source $ZSH/oh-my-zsh.sh

# User configuration
# ------------------------------------------------------------------------------

# Language
export LANG=en_US.UTF-8

# Aliases
source $HOME/.aliases.sh

# Add ~/.scripts dir to path
export PATH=$PATH:~/.scripts

# Default editor
export VISUAL="nvim"
