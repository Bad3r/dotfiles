# File: $HOME/.zshenv
# Desc: Used for setting user's environment variables;
#       it should not contain commands that produce output or assume the shell is attached to a TTY.
#       When this file exists it will always be read.
#

ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}"/zsh
source "${ZDOTDIR}"/env.d/.zshenv
