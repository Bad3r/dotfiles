#---------------------------------------------------------------------------
# *                            .Net Framework
#---------------------------------------------------------------------------

# Refrences
# https://wiki.archlinux.org/title/.NET
# https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete#zsh

if ! command_exists dotnet; then
    return
fi

# .Net Framework
# Environment variables moved to ~/.config/zsh/environment.zsh

# add .NET tools to $PATH (if directory exists)
[ -d "$HOME/.dotnet/tools" ] && PATH="$PATH:$HOME/.dotnet/tools"

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

  # This is not a variable assigment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}

compdef _dotnet_zsh_complete dotnet

