# Tool: Document Viewer Selection
# Desc: Set READER based on available options

# Priority: zathura > evince > okular > $BROWSER
if (( $+commands[zathura] )); then
    export READER="zathura"
elif (( $+commands[evince] )); then
    export READER="evince"
elif (( $+commands[okular] )); then
    export READER="okular"
elif [[ -n "$BROWSER" ]]; then
    # Use browser if set (browser.zsh should run first)
    export READER="$BROWSER"
else
    # Fallback if browser.zsh hasn't run yet
    export READER="xdg-open"
fi