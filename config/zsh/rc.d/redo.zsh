#---------------------------------------------------------------------------
# *                            Redo
#---------------------------------------------------------------------------

# https://github.com/barthr/redo
if ! (( $+commands[redo] )); then
  return
fi

export REDO_HISTORY_PATH="$HISTFILE"

# NOTE: REDO_HISTORY_PATH or HISTFILE must be set first
source "$(redo alias-file)"
