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

# Defaults
if command_exists kitty; then
  export TERM="xterm-kitty"
  export TERMINAL="kitty"
else
  export TERM="xterm-256color"
  export TERMINAL="xterm"
fi
export COLORTERM="truecolor"

if command_exists nvim; then
  export EDITOR="nvim"
  export DIFFPROG="nvim -d"
else
  export EDITOR="vi"
  export DIFFPROG="vimdiff"
fi

export VISUAL=$EDITOR

if command_exists nbrowser; then
  export BROWSER="nbrowser"
else
  export BROWSER="firefox"
fi

if command_exists zathura; then
  export READER="zathura"
else
  export READER="evince"
fi

if command_exists sxiv; then
  export IMAGE="sxiv"
else
  export IMAGE="feh"
fi

export OPENER="xdg-open"

export WM="i3"
export SHELL=$(which zsh)

# GPG
export GPG_TTY=$(tty)

# Git repo for my dotfiles
export DOTFILES="$HOME/dotfiles"

# set CUDA Compiler path
export CUDACXX=/opt/cuda/bin/nvcc

# Go
# Set go env vars
export GOBIN="$HOME/go/bin"
export GOPATH="$HOME/go"

# Rust
export CARGO_HOME="$XDG_CONFIG_HOME/cargo"

# Node
# Increase max memory
export NODE_OPTIONS="--max-old-space-size=16384"

# Firefox
# Enable WebRender compositor
# https://wiki.archlinux.org/title/Firefox/Tweaks#Enable_WebRender_compositor
export MOZ_WEBRENDER=1

# Enable hardware acceleration
# https://wiki.archlinux.org/title/Firefox/Tweaks#Enable_hardware_video_acceleration
export MOZ_X11_EGL=1

# set font for Nordic theme
# PKG: nordic-darker-theme-git
export THEME_FONT_FACE="MonoLisa"
export THEME_FONT_SIZE=11

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

# set default file manager
if command_exists nemo; then
  export FILE_MANAGER="nemo"
else
  export FILE_MANAGER="thunar"
fi

# set default video player
export VIDEO_PLAYER="mpv"

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/bin"

# PATH
typeset -U PATH path
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  # Doom Emacs
  "$HOME/.emacs.d/bin"
  # Go
  "${GOPATH}/bin"
  # Rust Cargo bins
  "${CARGO_HOME}/bin"
  # Ruby bins
  "$HOME/.gem/bin"
  # ClojureScript
  "/opt/clojurescript/bin/"
  # yarn (hardcoded to avoid slow command)
  "$HOME/.yarn/bin"
  # pub
  "$HOME/.pub-cache/bin"
  # NPM
  # Installation: mkdir -p ~/.npm-global && npm config set prefix '~/.npm-global'
  "$HOME/.npm-global/bin"
  # Claude
  "$HOME/.claude/local"

  "$path[@]")
export PATH

# Set max function nesting
export FUNCNEST=1000

# Disable DMABUF :( due to issue with Nvidia
# TODO: test if still needed
export WEBKIT_DISABLE_DMABUF_RENDERER=1

# Profiling output
[[ -n "$ZSH_PROFILE" ]] && zprof
