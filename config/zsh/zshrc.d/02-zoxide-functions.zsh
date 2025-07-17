# --------------------------------------------------------------------------- #
#*                                    Zoxide
# --------------------------------------------------------------------------- #

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    cd "$@"
}
# --------------------------------------------------------------------------- #
# Hook to add new entries to the database
function __zoxide_hook() {
    zoxide add "$(__zoxide_pwd)"
}

[[ -n '${precmd_functions[(r)__zoxide_hook]}' ]] || {
    precmd_functions+=(__zoxide_hook)
}

# --------------------------------------------------------------------------- #
#
# When using zoxide with --no-aliases, alias these internal functions as
# desired
#

# Jump to a directory using only keywords.
function __zoxide_z() {
    if [ "$#" -eq 0 ]; then
        __zoxide_cd ~
    elif [ "$#" -eq 1 ] && [ "$1" = '-' ]; then
        if [ -n "$OLDPWD" ]; then
            __zoxide_cd "$OLDPWD"
        else
            echo "zoxide: \\$OLDPWD is not set"
            return 1
        fi
    elif [ "$#" -eq 1 ] &&  [ -d "$1" ]; then
        __zoxide_cd "$1"
    else
        local __zoxide_result
        __zoxide_result="$(zoxide query -- "$@")" &&
            __zoxide_cd "$__zoxide_result"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    local __zoxide_result
    __zoxide_result="$(zoxide query -i -- "$@")"&&
        __zoxide_cd "$__zoxide_result"
}

function __zoxide_za() {
    zoxide add "$@"
}

function __zoxide_zq() {
    zoxide query "$@"
}

function __zoxide_zqi() {
    zoxide query -i "$@"
}

function __zoxide_zr() {
    zoxide remove "$@"
}

function __zoxide_zri() {
    zoxide remove -i "$@"
}

# --------------------------------------------------------------------------- #
# Convenient aliases for zoxide. Disable these using --no-aliases.
#
function __zoxide_unset() {
    \unalias "$@" &>/dev/null
    \unfunction "$@" &>/dev/null
    \unset "$@" &>/dev/null
}

__zoxide_unset 'j'
function j() {
    __zoxide_z "$@"
}

__zoxide_unset 'ji'
function ji() {
    __zoxide_zi "$@"
}

__zoxide_unset 'ja'
function ja() {
    __zoxide_za "$@"
}



__zoxide_unset 'jr'
function jr() {
    __zoxide_zr "$@"
}

__zoxide_unset 'jri'
function jri() {
    __zoxide_zri "$@"
}

#
# To initialize zoxide with zsh, add the following line to your zsh
# configuration file (usually ~/.zshrc):
#
# eval "$(zoxide init zsh)"
#