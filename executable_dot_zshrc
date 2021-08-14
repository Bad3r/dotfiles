
#!/bin/zsh

: <<'BDR'

                                    /   \                                      
                            )      ((   ))     (                               
                           /|\      ))_((     /|\                              
       (@)                / | \    (/\|/\)   / | \                 (@)         
       |-|---------------/--|-voV---\`|'/--Vov-|--\----------------|-|         
       |-|                    '^`   (o o)  '^`                     | |         
       | |                          `\Y/'                          |-|         
       |-|                                                         | |         
       | |               File...:    $HOME/.zshrc                  |-|         
       |-|               twitter:    @0xBader                      | |         
       | |               website:    SecBytes.net                  |-|         
       | |_________________________________________________________| |         
       |-|/`       l   /\ /         ( (       \ /\   l           `\|-|         
       (@)         l /   V           \ \       V   \ l             (@)         
                   l/                _) )_          \I                         
                                     `\ /' 

BDR

# catch non-zsh and non-interactive shells
[[ $- == *i* && $ZSH_VERSION ]] && SHELL=/usr/bin/zsh || return 0

autoload -Uz compinit && compinit

# --------------------------------------------------------------------------- #
#                                   History                                   #
# --------------------------------------------------------------------------- #

# Where to store zsh commands
HISTFILE=$HOME/.zsh_history
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


# --------------------------------------------------------------------------- #
#                                Miscellaneous                                #
# --------------------------------------------------------------------------- #

# Set Default Browser
export BROWSER="firefox-nightly"
# Set NeoVim as default editor
export EDITOR="nvim"
# Git repo for my dotfiles
export DOTFILES="$HOME/git/dotfiles"

# Man page max width
export MANWIDTH=80

# If command is a path, cd into it
setopt auto_cd
# remove trailing slash when tab-completing
setopt auto_remove_slash
# Resolve symbolic links
setopt chase_links
# Prevents accidantally overwriting a file
# use !< to force writing to the file
setopt noclobber
# Try to correct spelling of commands
setopt correct
# Tells the shell to understand vi keybind 
bindkey -v

REPORTTIME=5
# typeset -U path=($HOME/bin "${path[@]:#}")  # add ~/bin to pah

# Ruby Gems
GEM_HOME="$(xdg-user-dir)/gems"

# Skim/sk https://github.com/lotabout/skim
SKIM_DEFAULT_COMMAND="fd --type f"

# --------------------------------------------------------------------------- #
#                                    Locale                                   #
# --------------------------------------------------------------------------- #

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"


# --------------------------------------------------------------------------- #
#                                 Source Files                                #
# --------------------------------------------------------------------------- #

ZSH_DIR="$(xdg-user-dir)/.config/zsh"

# Source Alisas file (if it exists)
if [ -f "$ZSH_DIR"/aliases.zsh ]; then
    source "$ZSH_DIR"/aliases.zsh
fi

# Source ZSH Functions file (if it exists)
if [ -f "$ZSH_DIR"/functions.zsh ]; then
    source "$ZSH_DIR"/functions.zsh
fi

# check if antibody is installed
if (( $+commands[antibody] )); then
    source <(antibody init)
    antibody bundle < "$ZSH_DIR"/plugins.zsh
fi

# --------------------------------------------------------------------------- #
#                             Plugin Configuration                            #
# --------------------------------------------------------------------------- #

# ---------------------------------- Zoxide --------------------------------- #

eval "$(zoxide init zsh)"

# ------------------------------- Pure prompt ------------------------------- #

autoload -U promptinit; promptinit
prompt pure


# zstyle

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# use tmux for fzf-command
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# Default value
# zstyle ':fzf-tab:*' fzf-command fzf

# Preview
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0


# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap


# accept-line
# zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
# zstyle ':fzf-tab:*' accept-line enter

# groups
FZF_TAB_GROUP_COLORS=(
    $'\033[94m' $'\033[32m' $'\033[33m' $'\033[35m' $'\033[31m' $'\033[38;5;27m' $'\033[36m' \
    $'\033[38;5;100m' $'\033[38;5;98m' $'\033[91m' $'\033[38;5;80m' $'\033[92m' \
    $'\033[38;5;214m' $'\033[38;5;165m' $'\033[38;5;124m' $'\033[38;5;120m'
)
zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS
zstyle ':fzf-tab:*' show-group full
eval "$(navi widget zsh)"
