#!/bin/sh
# ~/.config/zsh/environment.zsh - Shared environment variables
# Sourced by ~/.profile (for GUI) and ~/.zshenv (for shells)

# Idempotency Guard: Ensure this file is only ever sourced once per session
[ -n "$_ZSH_ENV_SOURCED" ] && return || export _ZSH_ENV_SOURCED=1

# Defaults
if command -v kitty >/dev/null 2>&1; then
  export TERM="xterm-kitty"
  export TERMINAL="kitty"
else
  export TERM="xterm-256color"
  export TERMINAL="xterm"
fi
export COLORTERM="truecolor"

if command -v nvim >/dev/null 2>&1; then
  export EDITOR="nvim"
  export DIFFPROG="nvim -d"
else
  export EDITOR="vi"
  export DIFFPROG="vimdiff"
fi

export VISUAL=$EDITOR

if command -v nbrowser >/dev/null 2>&1; then
  export BROWSER="nbrowser"
else
  export BROWSER="firefox"
fi

if command -v zathura >/dev/null 2>&1; then
  export READER="zathura"
else
  export READER="evince"
fi

if command -v sxiv >/dev/null 2>&1; then
  export IMAGE="sxiv"
else
  export IMAGE="feh"
fi

export OPENER="xdg-open"

export WM="i3"
export SHELL=$(which zsh)

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

# set default file manager
if command -v nemo >/dev/null 2>&1; then
  export FILE_MANAGER="nemo"
else
  export FILE_MANAGER="thunar"
fi

# set default video player
export VIDEO_PLAYER="mpv"

# Disable DMABUF :( due to issue with Nvidia
# TODO: test if still needed
export WEBKIT_DISABLE_DMABUF_RENDERER=1

# From ~/.zshenv - Firefox/Nvidia section
# https://github.com/elFarto/nvidia-vaapi-driver#firefox
export NVD_BACKEND=direct
export LIBVA_DRIVER_NAME=nvidia
export MOZ_DISABLE_RDD_SANDBOX=1

# From rc.d/dotnet.zsh
export DOTNET_ROOT=/opt/dotnet
# disable telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1