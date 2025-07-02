
# This script sets up the zsh shell environment by loading configuration files from specific directories.
# It also loads the prompt and sets the window title to display the current user, host, and working directory.
# Additionally, it sets up key bindings vi-like navigation.

# catch non-zsh and non-interactive shells
[[ $- == *i* && $ZSH_VERSION ]] && SHELL=/usr/bin/zsh || return 0

# set debug mode
DEBUG=1

# Define an array of directories to load .zsh files from
#    "${ZSH_CONF_DIR}/env.d"
local config_dirs=(
    "${ZSH_CONF_DIR}/zshrc.d"
    "${ZSH_CONF_DIR}/func.d"
    "${ZSH_CONF_DIR}/rc.d"
    "${ZSH_CONF_DIR}/alias.d"
)

# Iterate over each directory and source all .zsh files
for dir in "${config_dirs[@]}"; do
    for file in "$dir"/*.zsh; do
        source "$file"
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
export DOTFILES="$(xdg-user-dir)/dotfiles"

# set CUDA Compiler path
export CUDACXX=/opt/cuda/bin/nvcc

# Go
# Set go env vars
export GOBIN="$(xdg-user-dir)/go/bin"
export GOPATH="$(xdg-user-dir)/go"

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

mkdir -p "$(xdg-user-dir)/.local/bin"
mkdir -p "$(xdg-user-dir)/bin"

# PATH
typeset -U PATH path
path=(
    "$(xdg-user-dir)/.local/bin"
    "$(xdg-user-dir)/bin"
    # Doom Emacs
    "$(xdg-user-dir)/.emacs.d/bin"
    # Go
    "${GOPATH}/bin"
    # Rust Cargo bins
    "${CARGO_HOME}/bin"
    # Ruby bins
    "$(xdg-user-dir)/.gem/bin"
    # ClojureScript
    "/opt/clojurescript/bin/"
    # yarn
    "$(yarn global bin)"
    # pub
    "$(xdg-user-dir)/.pub-cache/bin"
    # NPM
    # Installation: mkdir -p ~/.npm-global && npm config set prefix '~/.npm-global'
    "$(xdg-user-dir)/.npm-global/bin"
    # Claude
    "$(xdg-user-dir)/.claude/local"

    "$path[@]")
export PATH

# Set max function nesting
export FUNCNEST=1000

# Disable DMABUF :( due to issue with Nvidia
# TODO: test if still needed
export WEBKIT_DISABLE_DMABUF_RENDERER=1

# Claude Code
# Defaults: Opus 4: 32k, Sonnet 4: 64k
# To reset to default set to `1`
export CLAUDE_CODE_MAX_OUTPUT_TOKENS=48000
