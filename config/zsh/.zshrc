# catch non-zsh and non-interactive shells
[[ $- == *i* && $ZSH_VERSION ]] && SHELL=/usr/bin/zsh || return 0

# set debug mode
DEBUG=0

# Profiling
[[ -n "$ZSH_PROFILE" ]] && zmodload zsh/zprof

# Define an array of directories to load .zsh files from
#    "${ZSH_CONF_DIR}/env.d"
local config_dirs=(
  "${ZSH_CONF_DIR}/zshrc.d"
  "${ZSH_CONF_DIR}/func.d"
  "${ZSH_CONF_DIR}/rc.d"
  "${ZSH_CONF_DIR}/alias.d"
)

# Define files to lazy load (high-impact on startup time)
local lazy_load_files=(
  "zoxide.zsh"
  "dotnet.zsh"
  "gh_cli.zsh"
)

for dir in "${config_dirs[@]}"; do
  for file in "$dir"/*.zsh; do
    local should_lazy_load=0
    local filename="${file:t}"

    if [[ "$dir" == "${ZSH_CONF_DIR}/rc.d" ]]; then
      for lazy_file in "${lazy_load_files[@]}"; do
        if [[ "$filename" == "$lazy_file" ]]; then
          should_lazy_load=1
          break
        fi
      done
    fi

    if [[ $should_lazy_load -eq 1 ]]; then
      # Set up lazy loading based on the file
      case "$filename" in
      "zoxide.zsh")
        # Create wrapper functions for zoxide commands
        lazy_load_command "j" "$file"
        lazy_load_command "ji" "$file"
        lazy_load_command "zoxide" "$file"
        ;;
      "dotnet.zsh")
        lazy_load_command "dotnet" "$file"
        ;;
      "atuin.zsh")
        lazy_load_command "atuin" "$file"
        ;;
      "gh_cli.zsh")
        lazy_load_command "gh" "$file"
        lazy_load_command "ghcs" "$file"
        lazy_load_command "ghce" "$file"
        ;;
      esac
    else
      # Source normally
      source "$file"
    fi
  done
done

# arrow up/down to navigate history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# vi-like navigation bindings
bindkey "^h" backward-word
bindkey "^j" down-line-or-beginning-search
bindkey "^k" up-line-or-beginning-search
bindkey "^l" forward-word

bindkey "^u" backward-kill-word
bindkey "^w" backward-kill-word

# Environment variables moved to ~/.config/zsh/environment.zsh

# GPG
export GPG_TTY=$(tty)


# if fc-list | grep -i "monolisa" &> /dev/null; then
#     export THEME_FONT_FACE="MonoLisa"
#     export THEME_FONT_SIZE=11
# elif fc-list | grep -i "ibm plex mono" &> /dev/null; then
#     export THEME_FONT_FACE="IBM Plex Mono"
#     export THEME_FONT_SIZE=11
# else
#     export THEME_FONT_FACE="JetBrains Mono"
#     export THEME_FONT_SIZE=11
# fi


mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/bin"

# PATH configuration moved to ~/.profile

# Set max function nesting
export FUNCNEST=1000


# Profiling output
[[ -n "$ZSH_PROFILE" ]] && zprof
