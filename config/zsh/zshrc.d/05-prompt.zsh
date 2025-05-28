
# Set prompt to starship if available otherwise use Pure prompt

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
else
  # load default prompt
  autoload -U promptinit
  promptinit
  prompt pure
fi