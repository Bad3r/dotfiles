# File: $HOME/.zshenv
# Desc: Used for setting user's environment variables;
#       it should not contain commands that produce output or assume the shell is attached to a TTY.
#       When this file exists it will always be read.

# XDG Base Directory - MUST stay in ~/.zshenv for early/universal access
# (Different from XDG User Directories in ~/.config/user-dirs.dirs)
# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:=$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:=$HOME/.local/share}"

# ZSH - MUST stay in $HOME/.zshenv for bootstrapping
# ZDOTDIR is required by Zsh to find its config files (.zshrc, etc.)
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CONF_DIR=$ZDOTDIR

export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh"

# Source shared environment (with idempotency guard)
[ -f "${ZSH_CONF_DIR}/env.d/env" ] && . "${ZSH_CONF_DIR}/env.d/env"

