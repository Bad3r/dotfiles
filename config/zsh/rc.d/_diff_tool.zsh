# Tool: Diff Tool Selection
# Desc: Set DIFFPROG based on available options

# Priority: kitten diff > nvim -d > vimdiff (default)
if (( $+commands[kitty] )); then
    export DIFFPROG="kitten diff"
elif (( $+commands[nvim] )); then
    export DIFFPROG="nvim -d"
fi

# Note: Git difftool configuration should be managed separately in .gitconfig
# to avoid modifying global settings on every shell startup