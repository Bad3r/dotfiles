# Tool: Kitty
# Desc: GPU-accelerated terminal emulator

if ! (( $+commands[kitty] )); then
    return
fi

export TERM="xterm-kitty"
export TERMINAL="kitty"