
#!/bin/zsh

# catch non-zsh and non-interactive shells
[[ $- == *i* && $ZSH_VERSION ]] && SHELL=/usr/bin/zsh || return 0

autoload -Uz compinit && compinit

# History :

HISTFILE=$HOME/.zsh_history    	            # Where to store zsh commands.
HISTSIZE=1024		                        # Large history list.
SAVEHIST=1024			                    # Large history list.
setopt append_history		                # Append.
setopt inc_append_history	                # Write to history file immediately.
setopt hist_ignore_all_dups	  	            # Ignore duplicates.
unsetopt hist_ignore_space	  	            # Ignore space prefixed commands.
setopt hist_reduce_blanks	                # Trim blanks.
setopt hist_verify                          # Show command with history expansion.
setopt share_history                        # Share history between sessions.
setopt bang_hist                            # !keyword.

# set some defaults

# Variables

export BROWSER="firefox"		            # Set Firefox as default browser
export EDITOR="nvim"			            # Set NeoVim as default editor
export DOTFILES="$HOME/.dotfiles"	        # Git repo for my dotfiles
export MANWIDTH=90
ZSH_DIR=$DOTFILES/zsh

# Miscellaneous :

setopt auto_cd				                # If command is a path, cd into it.
setopt auto_remove_slash		            # remove trailing slash when tab-completing.
setopt chase_links			                # Resolve symbolic links.
setopt noclobber			                # Prevents accidantally overwriting a file. !<
setopt correct				                # Try to correct spelling of commands.
bindkey -v				                    # Tells the shell to understand vi commands.
typeset -U path=($HOME/bin "${path[@]:#}")  # add ~/bin to pah



# Source Files

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


# Pure prompt
fpath+=$ZSH_DIR/pure
autoload -U promptinit; promptinit
prompt pure


# Ruby exports

export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH

