#---------------------------------------------------------------------------
# *                            Bat
#---------------------------------------------------------------------------

# Configure bat for syntax highlighting and pager
if check_command bat; then
    eval "$(batman --export-env)"
    export BAT_THEME="Nord"
    export PAGER="bat"
    export MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'"
    alias cat="bat -p"
    alias catt="bat -pp"
    alias less="bat"
else
    export PAGER="less"
    export MANPAGER="less"
fi