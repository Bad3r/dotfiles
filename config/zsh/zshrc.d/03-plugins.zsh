# Zsh Plugins Configuration File

export ANTIDOTE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}/antidote
PLUGINS_CONF_FILE="${${(%):-%N}:A}" # this file
PLUGINS_DST_FILE="$ANTIDOTE_HOME/plugins.zsh"


if [[ ! "$PLUGINS_DST_FILE" -nt "$PLUGINS_CONF_FILE" ]]; then
    source "$DOTFILES/.antidote/antidote.zsh"
    mkdir -p "${PLUGINS_CONF_FILE:h}"
    antidote bundle <<-plugins >| "$PLUGINS_DST_FILE"
    # https://github.com/mattmc3/ez-compinit
    mattmc3/ez-compinit

    # https://github.com/zsh-users/zsh-completions
    zsh-users/zsh-completions kind:fpath path:src

    # https://github.com/Aloxaf/fzf-tab
    Aloxaf/fzf-tab

    # https://github.com/mattmc3/zfunctions
    mattmc3/zfunctions

    # https://github.com/zsh-users/zsh-autosuggestions
    zsh-users/zsh-autosuggestions

    # https://github.com/zdharma-continuum/fast-syntax-highlighting
    zdharma-continuum/fast-syntax-highlighting kind:defer

    # https://github.com/zsh-users/zsh-history-substring-search
    zsh-users/zsh-history-substring-search

    #  https://github.com/evanthegrayt/vagrant-box-wrapper
    # evanthegrayt/vagrant-box-wrapper

    # https://github.com/NullSense/fuzzy-sys
    # Utility for using systemctl interactively via junegunn/fzf.
    NullSense/fuzzy-sys # command: $ fuzzy-sys

    # https://github.com/g-plane/pnpm-shell-completion
    # g-plane/pnpm-shell-completion

    # https://github.com/hlissner/zsh-autopair
    hlissner/zsh-autopair

    # TODO: Review Docs
    # https://github.com/wfxr/forgit
    wfxr/forgit

    # NOTE: Replaced with starship prompt (seperate package)
    # https://github.com/sindresorhus/pure
    # sindresorhus/pure     kind:fpath
plugins
fi

source "$PLUGINS_DST_FILE"

# Set path to completion dump file
# Must be after loading mattmc3/ez-compinit
compinit -d "${ZSH_CONF_DIR:-$HOME/.config/zsh}/completion.d/.zshcompdump"
