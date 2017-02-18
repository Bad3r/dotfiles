
#------------------------------
#History stuff 
#------------------------------
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

autoload -Uz compinit
compinit

#------------------------------
#antigen             
#------------------------------
# antigen bundle github-user/repo --branch=develop

source /usr/share/zsh/scripts/antigen/antigen.zsh
antigen update
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle https://github.com/zsh-users/zsh-autosuggestions --branch=master
antigen bundle djui/alias-tips
antigen bundle https://github.com/oldratlee/hacker-quotes.git --branch=master
antigen bundle joel-porquet/zsh-dircolors-solarized.git

#----------------------------- 
# Variables
#------------------------------
export BROWSER="firefox"
export EDITOR="nvim"
bindkey -e # for emacs
fpath=( "$HOME/.zfunctions" $fpath )

# Pure prompt
autoload -U promptinit; promptinit
prompt pure

#------------------------------
# Alias stuff
#------------------------------
alias spm="sudo pacman"
alias ls="ls --color -Fa"
alias ll="ls --color -lha"
alias zshrc="$EDITOR ~/.zshrc"
alias xresources= "nvim ~/.Xresources"
alias vi'=nvim' # quick opening files with vim
alias fetch="neofetch"
alias colors="./colors.sh"

#------------------------------
#color man pages             
#------------------------------
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

