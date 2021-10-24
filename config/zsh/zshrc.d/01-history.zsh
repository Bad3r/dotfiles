# Set history file location
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/shell_history"
# Commands to ignore
HISTORY_IGNORE="(ls|exa|clear|pwd|zsh|exit|7z|mpv)"
# Large history list
HISTSIZE=100000
SAVEHIST=100000
# History timestamp
export HIST_STAMPS="yyyy-mm-dd"
# Append history
setopt append_history
# Write to history file immediately
setopt inc_append_history
# Ignore duplicate commands
setopt hist_ignore_all_dups
# Ignore space prefixed commands
unsetopt hist_ignore_space
# Trim blanks
setopt hist_reduce_blanks
# Show command with history expansion
setopt hist_verify
# Share history between sessions
setopt share_history
# !keyword to search history
setopt bang_hist

