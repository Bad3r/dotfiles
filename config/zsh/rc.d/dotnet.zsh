#---------------------------------------------------------------------------
# *                            .Net Framework
#---------------------------------------------------------------------------

# References
# https://wiki.archlinux.org/title/.NET
# https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete#zsh

if ! (( $+commands[dotnet] )); then
    return
fi

# Set DOTNET_ROOT if directory exists
if [ -d "/opt/dotnet" ]; then
    export DOTNET_ROOT=/opt/dotnet
fi

# zsh parameter completion for the dotnet CLI

_dotnet_zsh_complete() 
{
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}

compdef _dotnet_zsh_complete dotnet
