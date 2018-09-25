#
# Filename:         alias.zsh
# Description:
#                   Useful aliases for a smooth CLI experience.
#


# Arch Linux :

alias spm="sudo pacman"
alias packey="sudo pacman-key --init && sudo pacman-key --populate archlinux && sudo pacman-key --refresh-keys && sudo pacman -Syy"
alias wifi="nmcli dev wifi"
alias gita="pacman -Qm > ~/dotfiles/packmanlist.txt && git add ."


# Change defaults :

alias ls="ls --color=auto -Fa"
alias ll="ls --color=auto -lhaF"
alias dir="dir --color=auto"
alias vdir="vdir --color=auto"
alias grep="grep --color=always"
alias vi="$EDITOR"
alias ghc="ghc -dynamic"
alias gcc="gcc -ggdb -std=c99 -Wall -Wextra -pedantic"
alias cp="cp -i"
alias mv="mv -i"


# Fast access to files and scripts :

alias zshrc="$EDITOR ~/.zshrc"
alias xresources= "$EDITOR ~/.Xresources"
alias i3conf="$EDITOR ~/.i3/config"
alias colors="$DOTFILES/bin/colors.sh"
alias csdw="rsync -razhv --delete-after rit:~/Courses/ ~/Dropbox/RIT/Courses"
alias csup="rsync -razhv --delete-after  ~/Dropbox/RIT/Courses/ rit:~/Courses/"
alias cs="cd ~/Dropbox/RIT/Courses/CS243"


# Misc. :

alias tb="nc termbin.com 9999"			# Upload files to netcat-based pastebin. 
alias hex="hyx"					# CLI hex editor
alias fetch="neofetch"				# Show system information.

