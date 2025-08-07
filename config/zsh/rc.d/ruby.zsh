# Tool: Ruby
# Desc: Ruby and rbenv configuration

# Ruby Gems path ($GEM_HOME set in env.d/env)

if ! (( $+commands[rbenv] )); then
    return
fi

# Initialize rbenv
eval "$(rbenv init - zsh)"
