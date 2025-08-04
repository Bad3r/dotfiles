#---------------------------------------------------------------------------
# *                            Ruby
#---------------------------------------------------------------------------

# Ruby Gems environment variables (always set)
export GEM_HOME="$HOME/.gem"
export GEM_PATH="$HOME/.gem"

if ! (( $+commands[rbenv] )); then
    return
fi

# Initialize rbenv
eval "$(rbenv init - zsh)"
