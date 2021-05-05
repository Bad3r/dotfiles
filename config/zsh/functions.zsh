: <<'///'
                             /   \
 _                   )      ((   ))     (
(@)                 /|\      ))_((     /|\
|-|                / | \    (/\|/\)   / | \                 (@) 
| | --------------/--|-voV---\`|'/--Vov-|--\----------------|-|
|-|                    '^`   (o o)  '^`                     | |
| |                          `\Y/'                          |-|
|-|                                                         | |
| |                ~/.dotfiles/zsh/functions.zsh            |-|
|-|                         @0xBad3r                        | |
| |                       SecBytes.net                      |-|
|_|_________________________________________________________| |
(@)         l   /\ /         ( (       \ /\   l           `\|-|
            l /   V           \ \       V   \ l             (@)
            l/                _) )_          \I
                              `\ /'

///


# --------------------------------------------------------------------------- #
#                                expand aliases                               #
# --------------------------------------------------------------------------- #

globalias() {
   zle _expand_alias
   zle expand-word
   zle self-insert
}
zle -N globalias

# space expands all aliases, including global
bindkey -M emacs " " globalias
bindkey -M viins " " globalias

# control-space to make a normal space
bindkey -M emacs "^ " magic-space
bindkey -M viins "^ " magic-space

# normal space during searches
bindkey -M isearch " " magic-space

# Read markdown files in the terminal
mdv () {                                   
  pandoc $1 | lynx -stdin
}

# --------------------------------------------------------------------------- #
#                                     SUDO                                    #
# --------------------------------------------------------------------------- #
# Toggles "sudo" before the current/previous command by pressing:
# [ESC][ESC]

sudo-command-line() {                      
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="sudoedit $LBUFFER"
    elif [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="$EDITOR $LBUFFER"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line

# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line


# --------------------------------------------------------------------------- #
#                              Colored man pages                              #
# --------------------------------------------------------------------------- #

# if [[ "$OSTYPE" = solaris* ]]
# then
# 	if [[ ! -x "$HOME/bin/nroff" ]]
# 	then
# 		mkdir -p "$HOME/bin"
# 		cat > "$HOME/bin/nroff" <<EOF
# #!/bin/sh
# if [ -n "\$_NROFF_U" -a "\$1,\$2,\$3" = "-u0,-Tlp,-man" ]; then
# 	shift
# 	exec /usr/bin/nroff -u\$_NROFF_U "\$@"
# fi
# #-- Some other invocation of nroff
# exec /usr/bin/nroff "\$@"
# EOF
# 		chmod +x "$HOME/bin/nroff"
# 	fi
# fi

# function colored() {
# 	env \
# 		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
# 		LESS_TERMCAP_md=$(printf "\e[1;31m") \
# 		LESS_TERMCAP_me=$(printf "\e[0m") \
# 		LESS_TERMCAP_se=$(printf "\e[0m") \
# 		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
# 		LESS_TERMCAP_ue=$(printf "\e[0m") \
# 		LESS_TERMCAP_us=$(printf "\e[1;32m") \
# 		PAGER="${commands[less]:-$PAGER}" \
# 		_NROFF_U=1 \
# 		PATH="$HOME/bin:$PATH" \
# 			"$@"
# }

# function man() {
# 	colored man "$@"
# }


# --------------------------------------------------------------------------- #
#                               Extract Archives                              #
# --------------------------------------------------------------------------- #

alias x=extract

extract() {
	local remove_archive
	local success
	local extract_dir

	if (( $# == 0 )); then
		cat <<-'EOF' >&2
			Usage: extract [-option] [file ...]

			Options:
			    -r, --remove    Remove archive after unpacking.
		EOF
	fi

	remove_archive=1
	if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]; then
		remove_archive=0
		shift
	fi

	while (( $# > 0 )); do
		if [[ ! -f "$1" ]]; then
			echo "extract: '$1' is not a valid file" >&2
			shift
			continue
		fi

		success=0
		extract_dir="${1:t:r}"
		case "${1:l}" in
			(*.tar.gz|*.tgz) (( $+commands[pigz] )) &&
                { pigz -dc "$1" | tar xv } || tar zxvf "$1" ;;
			(*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$1" ;;
			(*.tar.xz|*.txz)
				tar --xz --help &> /dev/null \
				&& tar --xz -xvf "$1" \
				|| xzcat "$1" | tar xvf - ;;
			(*.tar.zma|*.tlz)
				tar --lzma --help &> /dev/null \
				&& tar --lzma -xvf "$1" \
				|| lzcat "$1" | tar xvf - ;;
			(*.tar.zst|*.tzst)
				tar --zstd --help &> /dev/null \
				&& tar --zstd -xvf "$1" \
				|| zstdcat "$1" | tar xvf - ;;
			(*.tar) tar xvf "$1" ;;
			(*.tar.lz) (( $+commands[lzip] )) && tar xvf "$1" ;;
			(*.tar.lz4) lz4 -c -d "$1" | tar xvf - ;;
			(*.tar.lrz) (( $+commands[lrzuntar] )) && lrzuntar "$1" ;;
			(*.gz) (( $+commands[pigz] )) && pigz -dk "$1" ||
                gunzip -k "$1" ;;
			(*.bz2) bunzip2 "$1" ;;
			(*.xz) unxz "$1" ;;
			(*.lrz) (( $+commands[lrunzip] )) && lrunzip "$1" ;;
			(*.lz4) lz4 -d "$1" ;;
			(*.lzma) unlzma "$1" ;;
			(*.z) uncompress "$1" ;;
			(*.zip|*.war|*.jar|*.sublime-package|*.ipa|*.ipsw|*.xpi|
                *.apk|*.aar|*.whl) unzip "$1" -d $extract_dir ;;
			(*.rar) unrar x -ad "$1" ;;
			(*.rpm) mkdir "$extract_dir" && cd "$extract_dir" &&
                rpm2cpio "../$1" | cpio --quiet -id && cd .. ;;
			(*.7z) 7za x "$1" ;;
			(*.deb)
				mkdir -p "$extract_dir/control"
				mkdir -p "$extract_dir/data"
				cd "$extract_dir"; ar vx "../${1}" > /dev/null
				cd control; tar xzvf ../control.tar.gz
				cd ../data; extract ../data.tar.*
				cd ..; rm *.tar.* debian-binary
				cd ..
			;;
			(*.zst) unzstd "$1" ;;
			(*)
				echo "extract: '$1' cannot be extracted" >&2
				success=1
			;;
		esac

		(( success = $success > 0 ? $success : $? ))
		(( $success == 0 )) && (( $remove_archive == 0 )) && rm "$1"
		shift
	done
}



# --------------------------------------------------------------------------- #
#                                    Zoxide                                   #
# --------------------------------------------------------------------------- #

# Utility functions for zoxide

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    cd "$@"
}
# --------------------------------------------------------------------------- #
#
# Hook configuration for zoxide.
#
# Hook to add new entries to the database
function __zoxide_hook() {
    zoxide add "$(__zoxide_pwd)"
}

# Initialize hook
[[ -n "${precmd_functions[(r)__zoxide_hook]}" ]] || {
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

# Add a new entry to the database.
function __zoxide_za() {
    zoxide add "$@"
}

# Query an entry from the database using only keywords.
function __zoxide_zq() {
    zoxide query "$@"
}

# Query an entry from the database using interactive selection.
function __zoxide_zqi() {
    zoxide query -i "$@"
}

# Remove an entry from the database using the exact path.
function __zoxide_zr() {
    zoxide remove "$@"
}

# Remove an entry from the database using interactive selection.
function __zoxide_zri() {
    zoxide remove -i "$@"
}

# --------------------------------------------------------------------------- #
#
# Convenient aliases for zoxide. Disable these using --no-aliases.
#

# Remove definitions.
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

__zoxide_unset 'jq'
function jq() {
    __zoxide_zq "$@"
}

__zoxide_unset 'jqi'
function jqi() {
    __zoxide_zqi "$@"
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