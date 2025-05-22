# rc.d/redo.zsh

# https://github.com/barthr/redo

# TODO: check if needed otherwise use $HISTFILE. Might be related to atuin?
export REDO_HISTORY_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/shell_history"

# NOTE: REDO_HISTORY_PATH or HISTFILE must be set first
if command -v redo &> /dev/null; then
  source "$(redo alias-file)"
fi
