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
# disable telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1


# add .NET to $PATH
typeset -U PATH path
path=(
        "$(xdg-user-dir)/.dotnet/tools"
        "$path[@]")
export PATH

export DOTNET_ROOT=/opt/dotnet

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

