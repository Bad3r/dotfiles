
#!/bin/zsh

# catch non-zsh and non-interactive shells
[[ $- == *i* && $ZSH_VERSION ]] && SHELL=/usr/bin/zsh || return 0

autoload -Uz compinit && compinit

# --------------------------------------------------------------------------- #
#                                   History                                   #
# --------------------------------------------------------------------------- #

# Where to store zsh commands
HISTFILE=$HOME/.zsh_history
# Large history list
HISTSIZE=100000
SAVEHIST=100000
# Append history
setopt append_history
# Write to history file immediately
setopt inc_append_history
# Ignore duplicate commands
setopt hist_ignore_all_dups
# Ignore space prefixed commands
unsetopt hist_ignore_space
# Trim blanks
setopt hist_reduce_blanks
# Show command with history expansion
setopt hist_verify
# Share history between sessions
setopt share_history
# !keyword to search history
setopt bang_hist


# --------------------------------------------------------------------------- #
#                                Miscellaneous                                #
# --------------------------------------------------------------------------- #

# Set Default Browser
export BROWSER="firefox"
# Set NeoVim as default editor
export EDITOR="nvim"
# Git repo for my dotfiles
export DOTFILES="$HOME/git/dotfiles"

# Man page max width
export MANWIDTH=80

# If command is a path, cd into it
setopt auto_cd
# remove trailing slash when tab-completing
setopt auto_remove_slash
# Resolve symbolic links
setopt chase_links
# Prevents accidantally overwriting a file
# use !< to force writing to the file
setopt noclobber
# Try to correct spelling of commands
setopt correct
# Tells the shell to understand vi keybind 
bindkey -v

REPORTTIME=5
# typeset -U path=($HOME/bin "${path[@]:#}")  # add ~/bin to pah

# Ruby Gems
GEM_HOME="$(xdg-user-dir)/gems"

# --------------------------------------------------------------------------- #
#                                    Locale                                   #
# --------------------------------------------------------------------------- #

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"


# --------------------------------------------------------------------------- #
#                                 Source Files                                #
# --------------------------------------------------------------------------- #

ZSH_DIR="$(xdg-user-dir)/.config/zsh"

# Source Alisas file (if it exists)
if [ -f $ZSH_DIR/aliases.zsh ]; then
    source $ZSH_DIR/aliases.zsh
fi

# Source ZSH Functions file (if it exists)
if [ -f $ZSH_DIR/functions.zsh ]; then
    source $ZSH_DIR/functions.zsh
fi

# check if antibody is installed
if (( $+commands[antibody] )); then
  source <(antibody init)
    antibody bundle < $ZSH_DIR/plugins.zsh
fi

# --------------------------------------------------------------------------- #
#                             Plugin Configuration                            #
# --------------------------------------------------------------------------- #

# ---------------------------------- Zoxide --------------------------------- #

eval "$(zoxide init zsh)"

# ------------------------------- Pure prompt ------------------------------- #

autoload -U promptinit; promptinit
prompt pure
