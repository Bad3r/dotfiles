# File: $ZDOTDIR/.zshenv
# Desc: Used for setting user's environment variables;
#       it should not contain commands that produce output or assume the shell is attached to a TTY.
#       When this file exists it will always be read.
#
# PATH
typeset -U PATH path
path=(
        "$(xdg-user-dir)/.local/bin"
        "$(xdg-user-dir)/bin"
        "$path[@]")
export PATH
#
# XDG
# Add environment variables for the XDG directory specification
export XDG_CONFIG_HOME="$(xdg-user-dir)/.config"
export XDG_CACHE_HOME="$(xdg-user-dir)/.cache"
export XDG_DATA_HOME="$(xdg-user-dir)/.local/share"
#
#
# Set defaults
export TERM="xterm-kitty"
export VISUAL="nvim"
export EDITOR=$VISUAL
export BROWSER="firefox"
# GPG
export GPG_TTY=$(tty)
# Git repo for my dotfiles
export DOTFILES="$(xdg-user-dir)/dotfiles"


# Load all files from $ZDOTDIR/env.d directory
if [ -d "${ZDOTDIR}"/env.d ]; then
  for file in "${ZDOTDIR}"/env.d/*.env; do
    source $file
  done
fi
