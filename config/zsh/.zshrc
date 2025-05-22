#!/bin/zsh

# This script sets up the zsh shell environment by loading configuration files from specific directories.
# It also loads the prompt and sets the window title to display the current user, host, and working directory.
# Additionally, it sets up key bindings vi-like navigation.


# catch non-zsh and non-interactive shells
[[ $- == *i* && $ZSH_VERSION ]] && SHELL=/usr/bin/zsh || return 0

# Define an array of directories to load .zsh files from
local config_dirs=(
  "${ZDOTDIR}/zshrc.d"
  # "${ZDOTDIR}/alias.d"
  "${ZDOTDIR}/rc.d"
  "${ZDOTDIR}/func.d"
)

# Iterate over each directory and source all .zsh files if the directory exists
for dir in "${config_dirs[@]}"; do
  if [[ -d "$dir" ]]; then
    # Use glob qualifiers to silently handle cases with no matching files
    for file in "$dir"/*.zsh(.N); do
      source "$file"
    done
  fi
done



# load prompt
# autoload -U promptinit
# promptinit
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
else
  # load default prompt
  autoload -U promptinit
  promptinit
fi

# Set window title
function set_win_title() {
  echo -ne "\033]0; $USER@$HOST:${PWD/$HOME/~} \007"
}
precmd_functions+=(set_win_title)

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

# bindkey "^n" to reload zshrc
exec-zsh() {
  zle -I
  exec zsh <"$TTY"
}

zle -N exec-zsh
bindkey '^n' exec-zsh
