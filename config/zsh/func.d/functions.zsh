
#---------------------------------------------------------------------------
# *                            Copy
#---------------------------------------------------------------------------

# cpypath()
# desc: copies the path of given directory or file to the system clipboard
#          Copy current directory if no parameter
# dep: xsel
function cpypath {
  # If no argument passed, use current directory
  local file="${1:-.}"

  # If argument is not an absolute path, prepend $PWD
  [[ $file = /* ]] || file="$PWD/$file"

  # Copy the absolute path without resolving symlinks
  # If clipcopy fails, exit the function with an error
  print -n "${file:a}" | xsel --clipboard || return 1

  echo ${(%):-"%B${file:a}%b copied to clipboard."}
}

# cp()
# desc: copy files using rsync
cp() {
    rsync -av -HAX -hhh --progress "$@"
}
compdef _files cp

# cpv()
# desc: copy files using rsync with verbose output format
cpv() {
    rsync -av -HAX -hhh --out-format="[%t] %o: '%n', size %'''b, Last Modified: %M" "$@"
    # Format String
    # Example: 
    # [2022/10/17 12:24:40] send: 'Monokai Extended.tmTheme', Size:  49.15K, Last Modified: 2022/10/17-11:59:25
    # [%t] %o %n %'''b, Last Modified: %M
    #   - %t     : date and time stamp
    #   - %o     : operation type
    #   - %n     : filename
    #                 NOTE: consider replacing with %f for filepath
    #   - %'''b: file size in KiB/MiB (1024)
    #   - %M     : last modified date 
}
compdef _files cpv

# https://man.archlinux.org/man/rsync.1

# From man rsync: 
# -a, --archive archive mode; equals -rlptgoD (no -H,-A,-X)
# -H preserves hard-links, -A preserves ACLs, and -X preserves extended attributes.
# When I use rsync interactively I also use the vP options for added verbosity
# (pointless to use in a cron job unless you are logging and are interested in the information)

# -a                            archive mode
# -v                            increase verbosity
# -P                            same as --partial --progress (progress bar)
#                                   - keep partially transferred files
#                                   - show progress during transfer
# -H                            preserve hard links
# -A                            preserve ACLs (implies -p)
# -X                            preserve extended attributes
# -S                            handle sparse files efficiently
# --links, -l              copy symlinks as symlinks
# --group, -g              preserve group
# --backup, -b            make backups (see --suffix & --backup-dir)
#
# --rsh=COMMAND, -e
#                               This option allows you to choose  an  alternative  remote  shell
#                               program  to  use  for communication between the local and remote
#                               copies of rsync.  Typically, rsync is configured to use  ssh  by
#                               default, but you may prefer to use rsh on a local network.
#
# --suffix=SUFFIX        backup suffix (default ~ w/o --backup-dir)
# -hhh: outputs numbers in human-readable format, in units of 1024 (K, M, G, T).


#### Search ArchWiki
# Allows for spaces
wiki() {
    search_term="${${*}// /+}"
    lynx "https://wiki.archlinux.org/index.php\?search\=${search_term}"
}


#### d()
# Select a directory from a list of previously visited directorys (current session)
#  Recommended Options (set in *ops.zsh)
# setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups
PS3="❯ "
d() {
    local dir
    select dir in $dirstack; break
    test "x$dir" != x && cd "$dir" || exit
}

# --------------------------------------------------------------------------- #
#*                                expand aliases                                
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
#*                                     SUDO                                     
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
#*                               man pages                               
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

# function lessman() {
# 	env \
# 		LESS_TERMCAP_md=$(tput bold; tput setaf 4) \
# 		LESS_TERMCAP_me=$(tput sgr0) \
# 		LESS_TERMCAP_mb=$(tput blink) \
# 		LESS_TERMCAP_us=$(tput setaf 2) \
# 		LESS_TERMCAP_ue=$(tput sgr0) \
# 		LESS_TERMCAP_so=$(tput smso; tput setaf 3) # yellow \
# 		LESS_TERMCAP_se=$(tput rmso) \
# 		PAGER="${commands[less]:-$PAGER}" \
# 		man "$@"
# }



# --------------------------------------------------------------------------- #
#*                               Extract Archives                               
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

#---------------------------------------------------------------------------
# *                            Return zsh Statistics
#---------------------------------------------------------------------------

function zsh_stats() {
  fc -l 1 \
    | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]*100/count "% " a }' \
    | grep -v "./" | sort -nr | head -n 20 | column -c3 -s " " -t | nl
}

#---------------------------------------------------------------------------
# *                            URL Encoding & Decoding
#---------------------------------------------------------------------------

# Required for $langinfo
zmodload zsh/langinfo

# URL-encode a string
#
# Encodes a string using RFC 2396 URL-encoding (%-escaped).
# See: https://www.ietf.org/rfc/rfc2396.txt
#
# By default, reserved characters and unreserved "mark" characters are
# not escaped by this function. This allows the common usage of passing
# an entire URL in, and encoding just special characters in it, with
# the expectation that reserved and mark characters are used appropriately.
# The -r and -m options turn on escaping of the reserved and mark characters,
# respectively, which allows arbitrary strings to be fully escaped for
# embedding inside URLs, where reserved characters might be misinterpreted.
#
# Prints the encoded string on stdout.
# Returns nonzero if encoding failed.
#
# Usage:
#  urlencode [-r] [-m] [-P] <string> [<string> ...]
#
#    -r causes reserved characters (;/?:@&=+$,) to be escaped
#
#    -m causes "mark" characters (_.!~*''()-) to be escaped
#
#    -P causes spaces to be encoded as '%20' instead of '+'
function urlencode() {
  emulate -L zsh
  local -a opts
  zparseopts -D -E -a opts r m P

  local in_str="$@"
  local url_str=""
  local spaces_as_plus
  if [[ -z $opts[(r)-P] ]]; then spaces_as_plus=1; fi
  local str="$in_str"

  # URLs must use UTF-8 encoding; convert str to UTF-8 if required
  local encoding=$langinfo[CODESET]
  local safe_encodings
  safe_encodings=(UTF-8 utf8 US-ASCII)
  if [[ -z ${safe_encodings[(r)$encoding]} ]]; then
    str=$(echo -E "$str" | iconv -f $encoding -t UTF-8)
    if [[ $? != 0 ]]; then
      echo "Error converting string from $encoding to UTF-8" >&2
      return 1
    fi
  fi

  # Use LC_CTYPE=C to process text byte-by-byte
  local i byte ord LC_ALL=C
  export LC_ALL
  local reserved=';/?:@&=+$,'
  local mark='_.!~*''()-'
  local dont_escape="[A-Za-z0-9"
  if [[ -z $opts[(r)-r] ]]; then
    dont_escape+=$reserved
  fi
  # $mark must be last because of the "-"
  if [[ -z $opts[(r)-m] ]]; then
    dont_escape+=$mark
  fi
  dont_escape+="]"

  # Implemented to use a single printf call and avoid subshells in the loop,
  # for performance (primarily on Windows).
  local url_str=""
  for (( i = 1; i <= ${#str}; ++i )); do
    byte="$str[i]"
    if [[ "$byte" =~ "$dont_escape" ]]; then
      url_str+="$byte"
    else
      if [[ "$byte" == " " && -n $spaces_as_plus ]]; then
        url_str+="+"
      else
        ord=$(( [##16] #byte ))
        url_str+="%$ord"
      fi
    fi
  done
  echo -E "$url_str"
}


# URL-decode a string
#
# Decodes a RFC 2396 URL-encoded (%-escaped) string.
# This decodes the '+' and '%' escapes in the input string, and leaves
# other characters unchanged. Does not enforce that the input is a
# valid URL-encoded string. This is a convenience to allow callers to
# pass in a full URL or similar strings and decode them for human
# presentation.
#
# Outputs the encoded string on stdout.
# Returns nonzero if encoding failed.
#
# Usage:
#   urldecode <urlstring>  - prints decoded string followed by a newline
function urldecode {
  emulate -L zsh
  local encoded_url=$1

  # Work bytewise, since URLs escape UTF-8 octets
  local caller_encoding=$langinfo[CODESET]
  local LC_ALL=C
  export LC_ALL

  # Change + back to ' '
  local tmp=${encoded_url:gs/+/ /}
  # Protect other escapes to pass through the printf unchanged
  tmp=${tmp:gs/\\/\\\\/}
  # Handle %-escapes by turning them into `\xXX` printf escapes
  tmp=${tmp:gs/%/\\x/}
  local decoded="$(printf -- "$tmp")"

  # Now we have a UTF-8 encoded string in the variable. We need to re-encode
  # it if caller is in a non-UTF-8 locale.
  local -a safe_encodings
  safe_encodings=(UTF-8 utf8 US-ASCII)
  if [[ -z ${safe_encodings[(r)$caller_encoding]} ]]; then
    decoded=$(echo -E "$decoded" | iconv -f UTF-8 -t $caller_encoding)
    if [[ $? != 0 ]]; then
      echo "Error converting string from UTF-8 to $caller_encoding" >&2
      return 1
    fi
  fi

  echo -E "$decoded"
}


# --------------------------------------------------------------------------- #
#*                                    Zoxide                                    
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
function run(){
  "$@" &>/dev/null &; disown
  exit 0
}



function vshell {
    # USAGE
    # vshell <SN> <TOKEN>
    # OR
    # vshell <TOKEN> <SN>
    if [[ "$1" = *"-"* ]]; then
        devID="$1"
        devSN="$2"
    else
        devID="$2"
        devSN="$1"
    fi
    vtoolbox device.shell -c $devID -a $devSN
}
