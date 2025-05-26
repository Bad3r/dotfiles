# list of plugins
# if antibody is installed; bundle zsh plugins

# TODO: replace with a mantained plugin manager
if ! command -v antibody &> /dev/null; then
    return
fi 

if hash antibody 2>/dev/null; then
    source <(antibody init)
    antibody bundle <<-plugins

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
    evanthegrayt/vagrant-box-wrapper

    # https://github.com/NullSense/fuzzy-sys
    # Utility for using systemctl interactively via junegunn/fzf.
    NullSense/fuzzy-sys

   # https://github.com/g-plane/pnpm-shell-completion
    g-plane/pnpm-shell-completion

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
