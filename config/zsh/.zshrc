# catch non-zsh and non-interactive shells
[[ $- == *i* && $ZSH_VERSION ]] && SHELL=$(which zsh) || return 0

# set debug mode
DEBUG=0

# Profiling
[[ -n "$ZSH_PROFILE" ]] && zmodload zsh/zprof

# Define an array of directories to load .zsh files from
#    "${ZSH_CONF_DIR}/env.d"
local config_dirs=(
  "${ZSH_CONF_DIR}/zshrc.d"
  "${ZSH_CONF_DIR}/func.d"
  "${ZSH_CONF_DIR}/rc.d"
  "${ZSH_CONF_DIR}/alias.d"
)

# Source all .zsh files from config directories
for file in ${^config_dirs}/*.zsh(N); do
  source "$file"
done

# arrow up/down to navigate history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# vi-like navigation bindings
bindkey "^h" backward-word
bindkey "^j" down-line-or-beginning-search
bindkey "^k" up-line-or-beginning-search
bindkey "^l" forward-word

bindkey "^u" backward-kill-word
bindkey "^w" backward-kill-word

# Environment variables moved to ~/.config/zsh/environment.zsh

# if fc-list | grep -i "monolisa" &> /dev/null; then
#     export THEME_FONT_FACE="MonoLisa"
#     export THEME_FONT_SIZE=11
# elif fc-list | grep -i "ibm plex mono" &> /dev/null; then
#     export THEME_FONT_FACE="IBM Plex Mono"
#     export THEME_FONT_SIZE=11
# else
#     export THEME_FONT_FACE="JetBrains Mono"
#     export THEME_FONT_SIZE=11
# fi

mkdir -p "$HOME/.local/bin" "$HOME/bin" 2>/dev/null

# Set max function nesting
export FUNCNEST=1000

# Profiling output
[[ -n "$ZSH_PROFILE" ]] && zprof
