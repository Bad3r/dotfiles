# Tool: Neovim
# Desc: Vim-fork focused on extensibility

if ! (( $+commands[nvim] )); then
    return
fi

export EDITOR="nvim"
export VISUAL="$EDITOR"