# Filename: .zshrc
# Description:
# 		my persoal zshell configurations


# History :

HISTFILE=$HOME/.zsh_history         	# Where to store zsh commands.
HISTSIZE=1024				# Large history list.
SAVEHIST=1024				# Large history list.
setopt append_history			# Append.
setopt inc_append_history		# Write to history file immediately.
setopt hist_ignore_all_dups		# Ignore duplicates.
unsetopt hist_ignore_space		# Ignore space prefixed commands.
setopt hist_reduce_blanks		# Trim blanks.
setopt hist_verify			# Show command with history expansion.
setopt share_history			# Share history between sessions.
setopt bang_hist			# !keyword.


# Miscellaneous :

setopt auto_cd				# If command is a path, cd into it.
setopt auto_remove_slash		# remove trailing slash when tab-completing.
setopt chase_links			# Resolve symbolic links.
setopt noclobber			# Prevents accidantally overwriting a file .
setopt correct				# Try to correct spelling of commands.


# Completion :

autoload -Uz compinit
compinit


# Variables

export BROWSER="firefox"		# Set Firefox as default browser.
export EDITOR="vim"			# Set Vim as default editor.
export DOTFILES="$HOME/dotfiles"	# Git repo for my dotfiles.
export QT_AUTO_SCREEN_SCALE_FACTOR=1.5	# Change QT apps scaling, default = 1.
export GDK_SCALE=1.5			# Change GTK apps scaling, default = 1.
export GDK_DPI_SCALE=1.5		# Change GTK apps DPI scaling, default = 1.
export ELM_SCALE=1.5			# Change elements scaling, default = 1.
bindkey -v				# Tells the shell to understand vi commands.


# Color man pages :

man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;35m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[4;36m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[3;34m") \
		PAGER="${commands[less]:-$PAGER}" \
		_NROFF_U=1 \
		PATH="$HOME/bin:$PATH" \
			man "$@"
}

# Source files :

if [ -f $HOME/bin/alias.zsh ]; then
	source $HOME/bin/alias.zsh
fi

if [ -f $HOME/bin/antigen.zsh ]; then
	source $HOME/bin/antigen.zsh
fi

