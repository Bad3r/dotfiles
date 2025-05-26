# File: $ZSH_CONF_DIR/.zshenv
# Desc: Used for setting user's environment variables;
#       it should not contain commands that produce output or assume the shell is attached to a TTY.
#       When this file exists it will always be read.
#

# Defaults
if command -v kitty &> /dev/null; then
    export TERM="xterm-kitty"
    export TERMINAL="kitty"
else
    export TERM="xterm-256color"
    export TERMINAL="xterm"
fi
export COLORTERM="truecolor"

if command -v nvim &> /dev/null; then
    export EDITOR="nvim"
    export DIFFPROG="nvim -d"
else
    export EDITOR="vi"
    export DIFFPROG="vimdiff"
fi

export VISUAL=$EDITOR

if command -v nbrowser &> /dev/null; then
    export BROWSER="nbrowser"
else
    export BROWSER="firefox"
fi

if command -v zathura &> /dev/null; then
    export READER="zathura"
else
    export READER="evince"
fi

if command -v sxiv &> /dev/null; then
    export IMAGE="sxiv"
else
    export IMAGE="feh"
fi

export OPENER="xdg-open"

if command -v bat &> /dev/null; then
    export PAGER="bat"
else
    export PAGER="less"
fi

export WM="i3"
export SHELL=$(which zsh)

# GPG
export GPG_TTY=$(tty)

# Git repo for my dotfiles
export DOTFILES="$(xdg-user-dir)/dotfiles"

# set CUDA Compiler path
export CUDACXX=/opt/cuda/bin/nvcc

# .Net Framework
# disable telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

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

if fc-list | grep -i "monolisa" &> /dev/null; then
    export THEME_FONT_FACE="MonoLisa"
    export THEME_FONT_SIZE=11
elif fc-list | grep -i "ibm plex mono" &> /dev/null; then
    export THEME_FONT_FACE="IBM Plex Mono"
    export THEME_FONT_SIZE=11
else
    export THEME_FONT_FACE="JetBrains Mono"
    export THEME_FONT_SIZE=11
fi


# set default file manager
if command -v nemo &> /dev/null; then
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
        "$path[@]")
export PATH

# Set max function nesting
export FUNCNEST=1000

# Disable DMABUF :( due to issue with Nvidia
# TODO: test if still needed
export WEBKIT_DISABLE_DMABUF_RENDERER=1

# Load zshrc
source "${ZSH_CONF_DIR}/.zshrc"