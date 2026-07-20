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
if (($+commands[exa])); then
    alias la="exa -hagl --git --icons"
    alias ls="exa --group-directories-first -a"
    alias ll="exa --group-directories-first -haglF --git"
    alias tree="exa --tree --level=2"
else
    alias l='ls -hagl'
    alias ll='ls -hagl'
    alias la='ls -lAh'
fi
