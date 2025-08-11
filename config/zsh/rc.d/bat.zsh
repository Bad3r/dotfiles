#---------------------------------------------------------------------------
# *                            Bat
#---------------------------------------------------------------------------

if ! (( $+commands[bat] )); then
    return
fi

# Configure bat for syntax highlighting and pager
eval "$(batman --export-env)"
export BAT_THEME="Nord"
export PAGER="bat"
export MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'"
alias cat="bat -pp"
alias less="bat -p"
