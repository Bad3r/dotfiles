# File: $HOME/.zshenv
# Desc: Used for setting user's environment variables;
#       it should not contain commands that produce output or assume the shell is attached to a TTY.
#       When this file exists it will always be read.
#
# XDG
# Add environment variables for the XDG directory specification
# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$(xdg-user-dir)/.config"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$(xdg-user-dir)/.cache"}
export XDG_DATA_HOME=${XDG_DATA_HOME:="$(xdg-user-dir)/.local/share"}

# locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ZSH
ZSH_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
source "${ZSH_CONF_DIR}/env.d/.zshenv"

# https://github.com/elFarto/nvidia-vaapi-driver#firefox
export NVD_BACKEND=direct
export MOZ_X11_EGL=1
export LIBVA_DRIVER_NAME=nvidia
export MOZ_DISABLE_RDD_SANDBOX=1

