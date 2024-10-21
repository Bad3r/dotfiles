##########################################
# Package Management
##########################################

# Pacman install with colored output
alias spm="sudo pacman --color=always -S"

# Yay aliases for AUR helper
alias yya="yay"
alias ya="yay"

# Update packages
alias up="yay -Syu"

# Update without confirmation
alias upc="yay -Syu --noconfirm"

# Install skipping integrity checks
alias yayskip="yay -S --mflags --skipinteg"

# Topgrade: Upgrade all software
alias tg="topgrade"
alias gt="topgrade"

##########################################
# File Management
##########################################

# Change permissions to 755 with sudo
alias chx="sudo chmod 755"

# Remove files with verbose output
alias rmv="rm -v"

# Force remove directories recursively
alias rmdf="rm -rfv"

# List block devices with detailed info
alias lsblk="lsblk -o NAME,FSTYPE,SIZE,TYPE,UUID,MOUNTPOINT"

# Show top 11 largest directories/files
alias ducks="du -cms * | sort -rn | head -11"

# Share content via termbin.com
alias tb="nc termbin.com 9999"

##########################################
# Compilation
##########################################

# GHC with dynamic linking
alias ghc="ghc -dynamic"

# GCC with debugging and strict standards
alias gcc="gcc -ggdb -std=c99 -Wall -Wextra -pedantic"

##########################################
# Networking
##########################################

# Ping with count of 5
alias ping="ping -c 5"

# Curl with silent, follow redirects, compressed
alias curl="curl -sJL --compressed"

# Wget with continue, content disposition, and progress
alias wget="wget -c --content-disposition --show-progress"

# Nmap with sudo and environment preservation
alias nmap="sudo -E nmap"

# Colorized IP command output
alias ip="ip -color=auto"
# Show all IP addresses
alias ipa="ip a"
# Ethernet interface
alias ipeth="ip a show enp0s31f6"
# WLAN interface
alias ipwlan="ip a show wlan0"
# Tunnel interface
alias iptun="ip a show tun0"

# Get external IP in JSON format
alias wtfip="curlie wtfismyip.com/json"

# List available Wi-Fi networks
alias wifi="nmcli dev wifi"

# List open network ports
alias ports="lsof -ni | grep -i"

##########################################
# Text Editors
##########################################

# Aliases for default editor
alias vi="$EDITOR"
alias vim="$EDITOR"

# Emacs in terminal mode
alias emacs="emacs -nw"
alias e="emacs -nw"

# Helix editor (https://helix-editor.com)
alias hx="helix"

# Visual Studio Code
alias vs="code"
alias vscode="vs"
alias vs.="vs ."
alias v.="vs ."

##########################################
# Configuration Files
##########################################

# Edit aliases file
alias vialias="$EDITOR ~/.config/zsh/zshrc.d/05-aliases.zsh"

# Edit Zsh configuration
alias zshrc="$EDITOR ~/.zshrc"

# Edit X resources
alias xresources="$EDITOR ~/.Xresources"

# Edit i3 window manager config
alias i3conf="$EDITOR ~/.i3/config"

##########################################
# System Information
##########################################

# Use fastfetch for system info
alias fetch="fastfetch"
alias neofetch="fastfetch"

##########################################
# Terminal Utilities
##########################################

# Shortcut for sudo
alias _="sudo "
alias suod="sudo"

# cd shortcut
alias ..="cd .."
alias ...="cd ../.."

# Clear shell variable named $
alias undoller="\$=''"

# Clear screen and display directory tree
alias cls="clear; tree"

# Clear screen shortcuts
alias cl="clear"
alias c="clear"
alias clr="clear"

# tldr with fzf preview
alias tl="tldr --list | fzf --preview 'tldr {} --color always' | xargs tldr"

# Hex viewer
alias hex="hyx"

# Display animated parrot
alias yeet="curl parrot.live"

# Exit shell
alias :q="exit"
alias q="exit"

# Grep processes with color
alias psf="ps -ef | grep --color=always"

# Human-readable disk usage with total
alias du="du -h -c"

# Upload content to ix.io
alias ixio="\curl -F 'f:1=<-' ix.io"

# Ripgrep with hidden files and ignoring VCS
alias rg="rg --hidden --ignore-vcs --require-git --glob \"!.git\""

##########################################
# Command Replacements
##########################################

# Use eva as bc if eva is installed
if (( ${+commands[eva]} )); then
    alias bc="eva"
fi

# Replace 'ls' & 'tree' with 'exa'
if command -v exa >/dev/null 2>&1; then
    alias ls="exa --group-directories-first -a --icons"
    alias ll="exa --group-directories-first -haglF --git --icons"
    alias tree="exa --tree --level=2"
fi


##########################################
# GUI Applications
##########################################

# Zathura PDF reader (https://pwmt.org/projects/zathura/)
alias zt="zathura"
alias za="zathura"

##########################################
# Systemd Management
##########################################

# Systemctl with sudo
alias sd="sudo systemctl"

# Service status
alias sds="systemctl status"

# Service status with sudo
alias scs="sudo systemctl status"

# Restart service
alias sr="sudo systemctl restart"

# List services
alias sl="sudo systemctl list-units --type=service"
alias sll="sudo systemctl list-units --type=service --all"
alias slll="sudo systemctl list-units --type=service --all --full"

# User-level systemctl
alias scu="systemctl --user"

# User services status
alias sus="systemctl --user status"

alias sul="systemctl --user list-units --type=service"
alias sull="systemctl --user list-units --type=service --all"
alias sulll="systemctl --user list-units --type=service --all --full"

# View system journal with sudo
alias journalctl="sudo journalctl"

# View kernel messages with color
alias dmesg="sudo dmesg -H --color=always"

##########################################
# Clipboard Management
##########################################

# Copy selection to clipboard using xclip
alias cpys="xclip -o | xclip -selection clipboard -i"

# Copy to clipboard using xsel
alias cpy="xsel --clipboard"

# Paste from clipboard
alias paste="xclip -o -sel clip"

##########################################
# Kitty Terminal
##########################################

# Kitty diff viewer
alias kdiff="kitty +kitten diff"

# Kitty image viewer
alias kimg="kitty +kitten icat"

# Kitty grep with hyperlinks
alias kgrep-url="kitty +kitten hyperlinked_grep -f"

# Kitty SSH client
alias kssh="kitty +kitten ssh"


##########################################
# Miscellaneous
##########################################

# nsxiv image viewer (https://github.com/nsxiv/nsxiv)
alias sx="nsxiv"
alias sxiv="nsxiv"

# Start input remapper service
alias inputremap="sudo input-remapper-service && \
input-remapper-control --command autoload"

# bat for syntax highlighting
alias catt="bat -pp"

# Alias xcp to cpx  (extended CP)
alias cpx="xcp"


##########################################
# Docker
##########################################

# Docker command aliases
alias dk="docker"
alias di="docker images"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dr="docker run"
alias drm="docker rm"
alias drmi="docker rmi"
alias drmf="docker rm -f"
alias dlf="docker logs -f"
alias ds="docker stop"
alias dstart="docker start"
alias dst="docker stats"
# Stop all containers
alias dsto="docker stop \$(docker ps -a -q)"

##########################################
# Docker Compose
##########################################

# Docker Compose command aliases
alias dc="docker-compose"
alias dce="docker-compose exec"
alias dcl="docker-compose logs"
alias dclf="docker-compose logs -f"
alias dco="docker-compose down"
alias dcps="docker-compose ps"
alias dcu="docker-compose up"

##########################################
# Git
##########################################

# General Git commands
alias g="git"
alias ga="git add"
alias gb="git branch --all"
alias gc="git commit"
# Diff with clean output
alias gd="git diff --output-indicator-new=\" \" --output-indicator-old=\" \""
alias gfu="git fetch upstream"
alias gi="git init"
alias gl="git log --graph"
alias gm="git merge"
alias gmum="git merge upstream/master"
alias gp="git push"
alias gpf="git push --force"
alias gr="git reset"
alias gs="git status -s"
alias gu="git pull"

# Advanced Git commands
alias gap="git add -p"
alias gbi="git bisect"
alias gca="git commit --amend --no-edit"
alias gcl="git clone --recursive"
alias gco="git checkout"
alias gcm="git commit -m"
alias gds="gd --staged"
alias gdt="git difftool"
alias gra="git remote add"
alias grb="git rebase"
alias grg="git remote get-url"
alias grl="git remote show"
alias grm="git rm"
alias grs="git remote set-url"
alias gsa="git stash apply"
alias gsl="git stash list"
alias gsp="git stash pop"
alias gss="git stash save"
alias gst="git diff --stat --color | cat"

##########################################
# Cloudflare
##########################################

# Cloudflare Warp CLI tool
alias warp="warp-cli"

# Wrangler CLI for Cloudflare Workers
alias wr="wrangler2"

##########################################
# Development Tools
##########################################

# pnpm package manager
alias pp="pnpm"

##########################################
# Paths
##########################################

# Export custom data paths
export mdata="/media/MineData/"
export bdata="/media/BankData/"
