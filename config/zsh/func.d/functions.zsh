: <<'BDR'

                                    /   \                                      
                            )      ((   ))     (                               
                           /|\      ))_((     /|\                              
       (@)                / | \    (/\|/\)   / | \                 (@)         
       |-|---------------/--|-voV---\`|'/--Vov-|--\----------------|-|         
       |-|                    '^`   (o o)  '^`                     | |         
       | |                          `\Y/'                          |-|         
       |-|                                                         | |         
       | |               File...:    .config/zsh/functions.zsh     |-|         
       |-|               twitter:    @0xBader                      | |         
       | |               website:    SecBytes.net                  |-|         
       | |_________________________________________________________| |         
       |-|/`       l   /\ /         ( (       \ /\   l           `\|-|         
       (@)         l /   V           \ \       V   \ l             (@)         
                   l/                _) )_          \I                         
                                     `\ /' 

BDR



# rsync
cp() {
    rsync -avPHAXS "$@"
}
compdef _files cpv
# https://man.archlinux.org/man/rsync.1
# -a archive mode
# -v increase verbosity
# -P same as --partial --progress (progress bar)
       # keep partially transferred files
       # show progress during transfer
# -H preserve hard links
# -A preserve ACLs (implies -p)
# -X preserve extended attributes
# -S handle sparse files efficiently

# Search ArchWiki
# Allows for spaces
wiki() {
    search_term="${${*}// /+}"
    lynx https://wiki.archlinux.org/index.php\?search\=${search_term}
}
# --------------------------------------------------------------------------- #
#                                expand aliases                                
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
#                                     SUDO                                     
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
#                               man pages                               
# --------------------------------------------------------------------------- #
# 
# termcap
# ks       make the keypad send commands
# ke       make the keypad send digits
# vb       emit visual bell
# mb       start blink
# md       start bold
# me       turn off bold, blink and underline
# so       start standout (reverse video)
# se       stop standout
# us       start underline
# ue       stop underline

#function man() {
#	env \
#		LESS_TERMCAP_md=$(tput bold; tput setaf 4) \
#		LESS_TERMCAP_me=$(tput sgr0) \
#		LESS_TERMCAP_mb=$(tput blink) \
#		LESS_TERMCAP_us=$(tput setaf 2) \
#		LESS_TERMCAP_ue=$(tput sgr0) \
#		LESS_TERMCAP_so=$(tput smso) \
#		LESS_TERMCAP_se=$(tput rmso) \
#		PAGER="${commands[less]:-$PAGER}" \
#		man "$@"
#}



# --------------------------------------------------------------------------- #
#                               Extract Archives                               
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
			(*.zip|*.war|*.jar|*.sublime-package|*.ipa|*.ipsw|
                *.xpi|*.apk|*.aar|*.whl) unzip "$1" -d $extract_dir ;;
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
#                                  tty Colors                                  
# --------------------------------------------------------------------------- #
# Dracula theme
printf %b '\e[40m' '\e[8]' # set default background to color 0 'dracula-bg'
printf %b '\e[37m' '\e[8]' # set default foreground to color 7 'dracula-fg'
printf %b '\e]P0282a36'    # redefine 'black'          as 'dracula-bg'
printf %b '\e]P86272a4'    # redefine 'bright-black'   as 'dracula-comment'
printf %b '\e]P1ff5555'    # redefine 'red'            as 'dracula-red'
printf %b '\e]P9ff7777'    # redefine 'bright-red'     as '#ff7777'
printf %b '\e]P250fa7b'    # redefine 'green'          as 'dracula-green'
printf %b '\e]PA70fa9b'    # redefine 'bright-green'   as '#70fa9b'
printf %b '\e]P3f1fa8c'    # redefine 'brown'          as 'dracula-yellow'
printf %b '\e]PBffb86c'    # redefine 'bright-brown'   as 'dracula-orange'
printf %b '\e]P4bd93f9'    # redefine 'blue'           as 'dracula-purple'
printf %b '\e]PCcfa9ff'    # redefine 'bright-blue'    as '#cfa9ff'
printf %b '\e]P5ff79c6'    # redefine 'magenta'        as 'dracula-pink'
printf %b '\e]PDff88e8'    # redefine 'bright-magenta' as '#ff88e8'
printf %b '\e]P68be9fd'    # redefine 'cyan'           as 'dracula-cyan'
printf %b '\e]PE97e2ff'    # redefine 'bright-cyan'    as '#97e2ff'
printf %b '\e]P7f8f8f2'    # redefine 'white'          as 'dracula-fg'
printf %b '\e]PFffffff'    # redefine 'bright-white'   as '#ffffff'
clear


# --------------------------------------------------------------------------- #
#                                    Zoxide                                    
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
