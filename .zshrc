#!/bin/zsh

# catch non-zsh and non-interactive shells
[[ $- == *i* && $ZSH_VERSION ]] && SHELL=/usr/bin/zsh || return 0

# History :

HISTFILE=$HOME/.zsh_history    	# Where to store zsh commands.
HISTSIZE=1024		                # Large history list.
SAVEHIST=1024			              # Large history list.
setopt append_history		       	# Append.
setopt inc_append_history	     	# Write to history file immediately.
setopt hist_ignore_all_dups	  	# Ignore duplicates.
unsetopt hist_ignore_space	  	# Ignore space prefixed commands.
setopt hist_reduce_blanks		    # Trim blanks.
setopt hist_verify			        # Show command with history expansion.
setopt share_history		      	# Share history between sessions.
setopt bang_hist			          # !keyword.

# set some defaults
export MANWIDTH=90

# path to the framework root directory
SIMPL_ZSH_DIR=$HOME/.zsh

# add ~/bin to the path if not already, the -U flag means 'unique'
typeset -U path=($HOME/bin "${path[@]:#}")

# used internally by zsh for loading themes and completions
typeset -U fpath=("$SIMPL_ZSH_DIR/"{completion,themes} $fpath)

# initialize the prompt
autoload -U promptinit && promptinit

# source shell configuration files
for f in "$SIMPL_ZSH_DIR"/{settings,plugins}/*?.zsh; do
    . "$f" 2>/dev/null
done

# Miscellaneous :

setopt auto_cd				    # If command is a path, cd into it.
setopt auto_remove_slash		# remove trailing slash when tab-completing.
setopt chase_links			    # Resolve symbolic links.
setopt noclobber			    # Prevents accidantally overwriting a file. !<
setopt correct				    # Try to correct spelling of commands.

# Variables

export BROWSER="firefox"		        # Set Firefox as default browser.
export EDITOR="nvim"			        # Set NeoVim as default editor.
export DOTFILES="$HOME/dotfiles"	    # Git repo for my dotfiles.
bindkey -v				                # Tells the shell to understand vi commands.


# Source files :


if [ -f $HOME/bin/alias.zsh ]; then
	source $HOME/bin/alias.zsh
fi


# Ruby exports

export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH



# uncomment these lines to disable the multi-line prompt
# add user@host, and remove the unicode line-wrap characters

# PROMPT_LNBR1=''
# PROMPT_MULTILINE=''
# PROMPT_USERFMT='%n%f@%F{red}%m'
# PROMPT_ECODE="%(?,,%F{red}%? )"

# load the prompt last
fpath=("$HOME/dotfiles/.zfunctions" $fpath)
autoload -U promptinit; promptinit
prompt pure

# system info and AL ascii art
fetch

# added by travis gem
[ -f /home/bdr/.travis/travis.sh ] && source /home/bdr/.travis/travis.sh
