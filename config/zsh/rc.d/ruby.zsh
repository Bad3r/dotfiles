# Ruby
# Ruby Gems
export GEM_HOME="$HOME/.gem"
export GEM_PATH="$HOME/.gem"

# Initialize rbenv if available
if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init - zsh)"
fi
