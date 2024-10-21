# File: $HOME/.zshenv
# Desc: Used for setting user's environment variables;
#       it should not contain commands that produce output or assume the shell is attached to a TTY.
#       When this file exists it will always be read.
#

export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
source "${ZDOTDIR}/env.d/.zshenv"

# https://github.com/elFarto/nvidia-vaapi-driver#firefox
export NVD_BACKEND=direct
export MOZ_X11_EGL=1
export LIBVA_DRIVER_NAME=nvidia
export MOZ_DISABLE_RDD_SANDBOX=1


export REDO_HISTORY_PATH="/home/chell/.cache/shell_history"
source "$(redo alias-file)"


