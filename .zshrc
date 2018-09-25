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


# Antigen plugin manager :

# antigen bundle github-user/repo --branch=develop
source /usr/share/zsh/share/antigen.zsh
#source /usr/share/zsh/scripts/antigen/antigen.zsh
antigen update
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle https://github.com/zsh-users/zsh-autosuggestions --branch=master
antigen bundle djui/alias-tips
#antigen bundle joel-porquet/zsh-dircolors-solarized.git
antigen apply


# Variables

export BROWSER="firefox"		# Set Firefox as default browser.
export EDITOR="vim"			# Set Vim as default editor.
export DOTFILES="$HOME/dotfiles"	# Git repo for my dotfiles.
export QT_AUTO_SCREEN_SCALE_FACTOR=1.5	# Change QT apps scaling, default = 1.
export GDK_SCALE=1.5			# Change GTK apps scaling, default = 1.
export GDK_DPI_SCALE=1.5		# Change GTK apps DPI scaling, default = 1.
export ELM_SCALE=1.5			# Change elements scaling, default = 1.
bindkey -v				# Tells the shell to understand vi commands.


# Aliases :

alias spm="sudo pacman"
alias ls="ls --color=auto -Fa"
alias ll="ls --color=auto -lhaF"
alias zshrc="$EDITOR ~/.zshrc"
alias xresources= "$EDITOR ~/.Xresources"
alias vi="$EDITOR" # quick opening files with vim
alias fetch="neofetch"
alias colors="~/dotfiles/colors.sh"
alias i3conf="$EDITOR ~/.i3/config"
alias pyh="cd ~/Dropbox/CS1-python/HomeWork/"
alias pyl="cd ~/Dropbox/CS1-python/Labs/"
alias ghc="ghc -dynamic"
alias csdw="rsync -razhv --delete-after rit:~/Courses/ ~/Dropbox/RIT/Courses"
alias csup="rsync -razhv --delete-after  ~/Dropbox/RIT/Courses/ rit:~/Courses/"
alias cs="cd ~/Dropbox/RIT/Courses/CS243"
alias gccrit="gcc -ggdb -std=c99 -Wall -Wextra -pedantic -c"
alias wifi="nmcli dev wifi"
# upload files to netcat-based command line pastebin.
alias tb="nc termbin.com 9999"
alias dir="dir --color=auto"
alias vdir="vdir --color=auto"
alias grep="grep --color=always"
alias packey="sudo pacman-key --init && sudo pacman-key --populate archlinux && sudo pacman-key --refresh-keys && sudo pacman -Syy"
# terminal hex editor
alias hex="hyx"
alias gita="pacman -Qm > ~/dotfiles/packmanlist.txt && git add ."
alias cp="cp -i"
alias mv="mv -i"


# Color man pages :
if [[ "$OSTYPE" = solaris* ]]
then
	if [[ ! -x "$HOME/bin/nroff" ]]
	then
		mkdir -p "$HOME/bin"
		cat > "$HOME/bin/nroff" <<EOF
#!/bin/sh
if [ -n "\$_NROFF_U" -a "\$1,\$2,\$3" = "-u0,-Tlp,-man" ]; then
	shift
	exec /usr/bin/nroff -u\$_NROFF_U "\$@"
fi
#-- Some other invocation of nroff
exec /usr/bin/nroff "\$@"
EOF
		chmod +x "$HOME/bin/nroff"
	fi
fi

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

