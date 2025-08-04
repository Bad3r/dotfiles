#---------------------------------------------------------------------------
# *                            Skim
#---------------------------------------------------------------------------

if ! (( $+commands[sk] )); then
    return
fi

# https://github.com/lotabout/skim
export SKIM_DEFAULT_COMMAND="fd --type f"

