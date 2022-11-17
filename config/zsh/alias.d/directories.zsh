
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias mkdir='mkdir -vp'
alias dir="dir --color=auto"
alias vdir="vdir --color=auto"
alias tempdir="mktemp --directory"
alias mktempdir="mktemp --directory"

# List directory contents
# Replace ls with exa if available https://github.com/ogham/exa
if (( $+commands[exa] )); then
    alias la="exa -hagl --git --icons"
    alias ll="exa -haglF --git --icons"
    alias ls="exa --icons"
    alias tree="exa --tree --icons --level=1"
else
    alias l='ls -hagl'
    alias ll='ls -hagl'
    alias la='ls -lAh'
fi
