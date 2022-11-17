
#!/bin/zsh

# catch non-zsh and non-interactive shells
[[ $- == *i* && $ZSH_VERSION ]] && SHELL=/usr/bin/zsh || return 0

#
# :§:§ Source Files §:§: #
#
# 
#---------------------------------------------------------------------------
# *                            :§:§: Source Files :§:§:
#---------------------------------------------------------------------------
# Load all files from "${ZDOTDIR}"/zshrc.d directory
if [ -d "${ZDOTDIR}"/zshrc.d ]; then
  for file in "${ZDOTDIR}"/zshrc.d/*.zsh; do
    source $file
  done
fi

# Load all files from "${ZDOTDIR}"/alias.d directory
if [ -d "${ZDOTDIR}"/alias.d ]; then
  for file in "${ZDOTDIR}"/alias.d/*.zsh; do
    source $file
  done
fi

# Load all files from "${ZDOTDIR}"/rc.d directory
if [ -d "${ZDOTDIR}"/rc.d ]; then
  for file in "${ZDOTDIR}"/rc.d/*.zsh; do
    source $file
  done
fi

# Load all files from "${ZDOTDIR}"/func.d directory
if [ -d "${ZDOTDIR}"/func.d ]; then
  for file in "${ZDOTDIR}"/func.d/*.zsh; do
    source $file
  done
fi


#---------------------------------------------------------------------------
# *                            :§:§: Prompt :§:§:
#---------------------------------------------------------------------------
# autoload -U promptinit
# promptinit
eval "$(starship init zsh)"

# Set window
function set_win_title(){
    echo -ne "\033]0; $USER@$HOST:${PWD/$HOME/~} \007"
}
precmd_functions+=(set_win_title)


