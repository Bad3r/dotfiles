# rc.d/redo.zsh

# https://github.com/barthr/redo

export REDO_HISTORY_PATH="$HISTFILE"

# NOTE: REDO_HISTORY_PATH or HISTFILE must be set first
if command -v redo &> /dev/null; then
  source "$(redo alias-file)"
fi
