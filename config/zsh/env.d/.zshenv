# File: $ZDOTDIR/.zshenv
# Desc: Used for setting user's environment variables;
#       it should not contain commands that produce output or assume the shell is attached to a TTY.
#       When this file exists it will always be read.
#


# XDG
# Add environment variables for the XDG directory specification
# https://wiki.archlinux.org/title/XDG_Base_Directory
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$(xdg-user-dir)/.config"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$(xdg-user-dir)/.cache"}
export XDG_DATA_HOME=${XDG_DATA_HOME:="$(xdg-user-dir)/.local/share"}


# PATH
typeset -U PATH path
path=(
        "$(xdg-user-dir)/.local/bin"
        "$(xdg-user-dir)/bin"
        # Doom Emacs
        "$(xdg-user-dir)/.emacs.d/bin"
        # Go
        "$(xdg-user-dir)/go/bin" 
        # Rust Cargo bins
        "$(xdg-user-dir)/.cargo/bin"
        "$path[@]")
export PATH


# locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Defaults
export TERM="xterm-kitty"
export COLORTERM="truecolor"
export TERMINAL="kitty"
export VISUAL="nvim"
export EDITOR=$VISUAL
export BROWSER="nbrowser"
export READER="zathura"
export IMAGE="sxiv"
export OPENER="xdg-open"
export PAGER="bat"
export WM="i3"

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
# add to path
export GOBIN="$(xdg-user-dir)/go/bin"
export GOPATH="$(xdg-user-dir)/go"

# QT
export QT_SELECT=6
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORMTHEME="qt6ct"
export QT_QPA_PLATFORM_PLUGIN_PATH="/usr/lib/qt/plugins"

# Ruby
# Ruby Gems
export GEM_HOME="$(xdg-user-dir)/gems"

# Node
# Increase max memory
export NODE_OPTIONS="--max-old-space-size=16384"

# Firefox
# Enable WebRender compositor
# https://wiki.archlinux.org/title/Firefox/Tweaks#Enable_WebRender_compositor
export MOZ_WEBRENDER=1

# set font for Nordic theme
# PKG: nordic-darker-theme-git
export THEME_FONT_FACE="MonoLisa"
export THEME_FONT_SIZE=11

# Paru
export PARU_CONF="$XDG_CONFIG_HOME/paru/paru.conf"