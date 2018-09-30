#!/bin/bash
#
# filename:         link.sh
# description:
#                   Link *nix configuration files.
#

set -e

if [ -f $HOME/dotfiles/bin/lib.sh ]; then
    echo "Dependencies found. Proceeding..."
    source $HOME/dotfiles/bin/lib.sh
else
    echo "Error: could not find dependent script(s)."
    exit 1
fi

#
# variables
#

LNFLAGS=''

#
# functions
#

# Excuse the pathetic faux type inferences.
# $flag -> $regex -> $path -> [char] -> null
link() {
    for file in $DOTFILES/$2; do
        if [ "$4" == "dot" ]; then
            ln $1 $file $3/.`basename $file`
        else
            ln $1 $file $3/`basename $file`
        fi
    done
}

#
# script
#

redp "Screening directory..."

# check for cloned repo
if [ ! -d $HOME/dotfiles ]; then
    redp "Error: dotfiles not found.\nAborting..."

    exit 1
fi

# check for ~/bin
if [ ! -d $HOME/bin ]; then
    redp "Error: ~/bin not found.\nCreating..."

    mkdir $HOME/bin

    greenp "Done."
fi

greenp "Done."

# specific nix
redp "`uname -s` kernel detected.\nLinking files specific to system..."

if [[ `uname -s` == 'Darwin' ]]; then
    # darwin
    LNFLAGS="-shfv"

    link $LNFLAGS "iterm*" $HOME

elif [[ `uname -s` == 'Linux' ]]; then
    # linux
    LNFLAGS="-sTfv"

    link $LNFLAGS "X*" $HOME dot
    link $LNFLAGS "redshift*" $HOME/.config
fi

greenp "Done."

# shared nix
redp "Linking shared *nix files..."

link $LNFLAGS "bin/*" $HOME/bin
link $LNFLAGS "z*" $HOME dot
link $LNFLAGS "tmux*" $HOME dot
link $LNFLAGS "emacs.d" $HOME dot
link $LNFLAGS "nvim" $HOME/.config
link $LNFLAGS "rgignore" $HOME/.config dot
link $LNFLAGS "neofet*" $HOME/.config

greenp "Done.\nAll dotfiles linked. Have a nice day."
