# File: $HOME/.zshenv
# Desc: Used for setting user's environment variables;
#       it should not contain commands that produce output or assume the shell is attached to a TTY.
#       When this file exists it will always be read.
#
# XDG Base Directory - MUST stay in ~/.zshenv for early/universal access
# (Different from XDG User Directories in ~/.config/user-dirs.dirs)
# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$(xdg-user-dir)/.config"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$(xdg-user-dir)/.cache"}
export XDG_DATA_HOME=${XDG_DATA_HOME:="$(xdg-user-dir)/.local/share"}

# locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ZSH
export ZSH_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export ZDOTDIR=$ZSH_CONF_DIR
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# Source shared environment (with idempotency guard)
[ -f "$HOME/.config/zsh/environment.zsh" ] && . "$HOME/.config/zsh/environment.zsh"

source "${ZSH_CONF_DIR}/env.d/.zshenv"

