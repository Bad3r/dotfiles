#---------------------------------------------------------------------------
# *                            History file configuration
#---------------------------------------------------------------------------

[ -z "$HISTFILE" ] && HISTFILE="${XDG_DATA_HOME}/zsh/zsh_history"

export HISTSIZE=2147483647 # LONG_MAX
export SAVEHIST=$HISTSIZE

# Commands to ignore
export HISTORY_IGNORE="(ls *|exa *|clear|pwd|zsh|exit|7z|mpv|cd ..|exit|pwd|* --help|vim|nvim|* *MineData*)"
export HISTIGNORE="&:[bf]g:c:clear:history:exit:q:pwd:* --help"
# Timestamp format
export HIST_STAMPS="yyyy-mm-dd"

#===========================================================================
# *                            History command configuration
#===========================================================================

# Append history
setopt append_history

# Write to history file immediately
setopt inc_append_history

# record timestamp of command in HISTFILE
setopt extended_history

# Ignore duplicate commands
setopt hist_ignore_all_dups

# delete duplicates first when HISTFILE size exceeds HISTSIZE
# redundant due to hist_ignore_all_dups being set
# setopt hist_expire_dups_first

# Ignore space prefixed commands
setopt hist_ignore_space

# Trim blanks
setopt hist_reduce_blanks

# Show command with history expansion
setopt hist_verify

# Share history between sessions
setopt share_history

# !keyword to search history
setopt bang_hist
