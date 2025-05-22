# list of plugins
# if antibody is installed; bundle zsh plugins

# TODO: replace with a mantained plugin manager
if ! command -v antibody &> /dev/null; then
    return
fi 

if hash antibody 2>/dev/null; then

    source <(antibody init)
    antibody bundle <<-plugins

    # https://github.com/zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-syntax-highlighting

    # https://github.com/zsh-users/zsh-autosuggestions
    zsh-users/zsh-autosuggestions

    # https://github.com/Aloxaf/fzf-tab
    Aloxaf/fzf-tab

    #  https://github.com/wfxr/forgit
    # wfxr/forgit

    #  https://github.com/evanthegrayt/vagrant-box-wrapper
    evanthegrayt/vagrant-box-wrapper

    # https://github.com/NullSense/fuzzy-sys
    # Utility for using systemctl interactively via junegunn/fzf.
    NullSense/fuzzy-sys

    # https://github.com/zsh-users/zsh-history-substring-search
    zsh-users/zsh-history-substring-search

   # https://github.com/g-plane/pnpm-shell-completion
    g-plane/pnpm-shell-completion

plugins

fi
