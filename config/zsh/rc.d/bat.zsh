#---------------------------------------------------------------------------
# *                            Bat
#---------------------------------------------------------------------------

if ! (($+commands[bat])); then
    return
fi

# Configure bat for syntax highlighting and pager
export BAT_THEME="TwoDark"
export PAGER="bat"
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias cat="bat -pp"
alias less="bat -p"
