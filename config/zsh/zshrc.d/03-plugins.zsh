
# list of plugins
# if antibody is installed; bundle zsh plugins
if (( $+commands[antibody] )); then
    source <(antibody init)
    antibody bundle <<- plugins
    # https://github.com/sindresorhus/pure
    # sindresorhus/pure

    # https://github.com/zsh-users/zsh-syntax-highlighting
    # zsh-users/zsh-syntax-highlighting

    # https://github.com/zdharma/fast-syntax-highlighting
    zdharma/fast-syntax-highlighting

    # https://github.com/zsh-users/zsh-autosuggestions
    zsh-users/zsh-autosuggestions

    # https://github.com/Aloxaf/fzf-tab
    Aloxaf/fzf-tab

    #  https://github.com/wfxr/forgit
    # wfxr/forgit

    #  https://github.com/evanthegrayt/vagrant-box-wrapper
    evanthegrayt/vagrant-box-wrapper

    # https://github.com/NullSense/fuzzy-sys
    NullSense/fuzzy-sys

    # https://github.com/spaceship-prompt/spaceship-prompt
    # spaceship-prompt/spaceship-prompt

plugins

fi
