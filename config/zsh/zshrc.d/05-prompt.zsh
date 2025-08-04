
#---------------------------------------------------------------------------
# *                            Prompt Configuration
#---------------------------------------------------------------------------

# Set prompt to starship if available otherwise use Pure prompt

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  # load default prompt
  autoload -U promptinit
  promptinit
  prompt pure
fi