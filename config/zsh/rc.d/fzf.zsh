# Use fzf
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh


# Nord theme
export FZF_DEFAULT_OPTS="
                                          --ansi
                                           --color 'fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C,pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B' 
                                           "
# Add preview 
#                                           --preview 'bat --color=always --style=full --line-range :300 {}' 
#                                          --preview-window 'right:60%'

export FZF_CTRL_T_COMMAND='$FZF_DEFAULT_COMMAND'


command -v fd > /dev/null && export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow  --color=always --exclude .git'
command -v bat > /dev/null && command -v tree > /dev/null && export FZF_DEFAULT_OPTS="$FZF_COMMON_OPTIONS"
command -v fd > /dev/null && export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
command -v fd > /dev/null && export FZF_CTRL_T_COMMAND='fd --type f --type d --hidden --follow --exclude .git'


# FZF scripts 
fzf-kill() {
 local pid
 if [[ "${UID}" != "0" ]]; then
     pid=$(ps -f -u ${UID} | sed 1d | fzf -m | awk '{print $2}')
 else
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
 fi

 if [[ "x$pid" != "x" ]]; then
    echo $pid | xargs kill "-${1:-9}"
 fi
 zle reset-prompt
}
zle -N fzf-kill
bindkey '^K' fzf-kill