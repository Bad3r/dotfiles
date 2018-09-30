#!/bin/bash
#
# filename:         lib.sh
# description:
#                   Don't reinvent the wheel. Put commonly used stuff here.
#

#
# variables
#

# paths
DOTFILES="$HOME/dotfiles"
BIN="$DOTFILES/bin"

# colors
CLEAR='\033[0m'
GREEN='\033[1;32m'
RED='\033[1;31m'

#
# functions
#

greenp() {
    echo -e ${GREEN}$1${CLEAR}
    sleep 0.5
}

redp() {
    echo -e ${RED}$1${CLEAR}
    sleep 1
}
