
#!/bin/zsh

: <<'BDR'

                                    /   \                                      
                            )      ((   ))     (                               
                           /|\      ))_((     /|\                              
       (@)                / | \    (/\|/\)   / | \                 (@)         
       |-|---------------/--|-voV---\`|'/--Vov-|--\----------------|-|         
       |-|                    '^`   (o o)  '^`                     | |         
       | |                          `\Y/'                          |-|         
       |-|                                                         | |         
       | |               File...:    $HOME/.zshrc                  |-|         
       |-|               twitter:    @0xBader                      | |         
       | |               website:    SecBytes.net                  |-|         
       | |_________________________________________________________| |         
       |-|/`       l   /\ /         ( (       \ /\   l           `\|-|         
       (@)         l /   V           \ \       V   \ l             (@)         
                   l/                _) )_          \I                         
                                     `\ /' 

BDR

# catch non-zsh and non-interactive shells
[[ $- == *i* && $ZSH_VERSION ]] && SHELL=/usr/bin/zsh || return 0
#

# --------------------------------------------------------------------------- #
#                                 Source Files                                #
# --------------------------------------------------------------------------- #

# Load all files from "${ZDOTDIR}"/zshrc.d directory
if [ -d "${ZDOTDIR}"/zshrc.d ]; then
  for file in "${ZDOTDIR}"/zshrc.d/*.zsh; do
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


## auto root ##

#autoRootTempFileDir="/dev/shm"

#source /opt/auto-root/auto-root.bash
#startAutoRootSession
#trap 'previous_command=$this_command; this_command=$BASH_COMMAND' DEBUG
#trap 'stopAutoRootSession' EXIT
#PROMPT_COMMAND=autoRootEvaluate

## end auto root ##

# autoload -U promptinit
# promptinit
eval "$(starship init zsh)"
