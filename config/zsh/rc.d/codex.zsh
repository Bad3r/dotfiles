if ! (( $+commands[codex] )); then
    return
fi

export CODEX_HOME="$XDG_CONFIG_HOME/codex"
