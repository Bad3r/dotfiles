
# list of plugins
# if antibody is installed; bundle zsh plugins
if (( $+commands[antibody] )); then
    source <(antibody init)
    antibody bundle <<- plugins

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

plugins

    #### Shortcuts

    # zsh-history-substring-search
    bindkey '^[[A' history-substring-search-up                  # arrow up
    bindkey '^[[B' history-substring-search-down                # arrow down
    bindkey -M emacs '^P' history-substring-search-up           # emacs mode
    bindkey -M emacs '^N' history-substring-search-down         # emacs mode
    bindkey -M vicmd 'k' history-substring-search-up            # Vim mode
    bindkey -M vicmd 'j' history-substring-search-down          # Vim  mode
    
fi

