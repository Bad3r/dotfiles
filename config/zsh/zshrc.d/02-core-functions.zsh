# Set window title
function set_win_title() {
  echo -ne "\033]0; $USER@$HOST:${PWD/$HOME/~} \007"
}
precmd_functions+=(set_win_title)


# bindkey "^n" to reload zshrc
exec-zsh() {
  zle -I
  exec zsh <"$TTY"
}

zle -N exec-zsh
bindkey '^n' exec-zsh


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
# 'cp'()
# desc: copy files using rsync
cp() {
  rsync -lav -HAX -hhh --progress "$@"
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

#---------------------------------------------------------------------------
# *                            Move
#---------------------------------------------------------------------------

mv() {
    if (( $# == 1 )); then
        command mv -vi "$1" .
    else
        command mv -vi "$@"
    fi
}


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
# Select a directory from a list of previously visited directories (current session)
#  Recommended Options (set in *ops.zsh)
# setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups
PS3="❯ "

d() {
  local dir
  select dir in $dirstack; do
    test "x$dir" != x && cd "$dir" || exit
  done
}

# cp()
# desc: copy files using rsync
cp() {
    rsync -HAX -hhh --progress "$@"
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

__sudo-replace-buffer() {
  local old=$1 new=$2 space=${2:+ }

  # if the cursor is positioned in the $old part of the text, make
  # the substitution and leave the cursor after the $new text
  if [[ $CURSOR -le ${#old} ]]; then
    BUFFER="${new}${space}${BUFFER#$old }"
    CURSOR=${#new}
  # otherwise just replace $old with $new in the text before the cursor
  else
    LBUFFER="${new}${space}${LBUFFER#$old }"
  fi
}

sudo-command-line() {
  # If line is empty, get the last run command from history
  [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

  # Save beginning space
  local WHITESPACE=""
  if [[ ${LBUFFER:0:1} = " " ]]; then
    WHITESPACE=" "
    LBUFFER="${LBUFFER:1}"
  fi

  {
    # If $SUDO_EDITOR or $VISUAL are defined, then use that as $EDITOR
    # Else use the default $EDITOR
    local EDITOR=${SUDO_EDITOR:-${VISUAL:-$EDITOR}}

    # If $EDITOR is not set, just toggle the sudo prefix on and off
    if [[ -z "$EDITOR" ]]; then
      case "$BUFFER" in
        sudoedit\ *) __sudo-replace-buffer "sudoedit" "" ;;
        sudo\ *) __sudo-replace-buffer "sudo" "" ;;
        *) LBUFFER="sudo $LBUFFER" ;;
      esac
      return
    fi

    # Check if the typed command is really an alias to $EDITOR

    # Get the first part of the typed command
    local cmd="${${(Az)BUFFER}[1]}"
    # Get the first part of the alias of the same name as $cmd, or $cmd if no alias matches
    local realcmd="${${(Az)aliases[$cmd]}[1]:-$cmd}"
    # Get the first part of the $EDITOR command ($EDITOR may have arguments after it)
    local editorcmd="${${(Az)EDITOR}[1]}"

    # Note: ${var:c} makes a $PATH search and expands $var to the full path
    # The if condition is met when:
    # - $realcmd is '$EDITOR'
    # - $realcmd is "cmd" and $EDITOR is "cmd"
    # - $realcmd is "cmd" and $EDITOR is "cmd --with --arguments"
    # - $realcmd is "/path/to/cmd" and $EDITOR is "cmd"
    # - $realcmd is "/path/to/cmd" and $EDITOR is "/path/to/cmd"
    # or
    # - $realcmd is "cmd" and $EDITOR is "cmd"
    # - $realcmd is "cmd" and $EDITOR is "/path/to/cmd"
    # or
    # - $realcmd is "cmd" and $EDITOR is /alternative/path/to/cmd that appears in $PATH
    if [[ "$realcmd" = (\$EDITOR|$editorcmd|${editorcmd:c}) \
      || "${realcmd:c}" = ($editorcmd|${editorcmd:c}) ]] \
      || builtin which -a "$realcmd" | command grep -Fx -q "$editorcmd"; then
      __sudo-replace-buffer "$cmd" "sudoedit"
      return
    fi

    # Check for editor commands in the typed command and replace accordingly
    case "$BUFFER" in
      $editorcmd\ *) __sudo-replace-buffer "$editorcmd" "sudoedit" ;;
      \$EDITOR\ *) __sudo-replace-buffer '$EDITOR' "sudoedit" ;;
      sudoedit\ *) __sudo-replace-buffer "sudoedit" "$EDITOR" ;;
      sudo\ *) __sudo-replace-buffer "sudo" "" ;;
      *) LBUFFER="sudo $LBUFFER" ;;
    esac
  } always {
    # Preserve beginning space
    LBUFFER="${WHITESPACE}${LBUFFER}"

    # Redisplay edit buffer (compatibility with zsh-syntax-highlighting)
    zle && zle redisplay # only run redisplay if zle is enabled
  }
}

zle -N sudo-command-line

# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line
bindkey -M viins '\e\e' sudo-command-line


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

#--------------------------------------------------------------------------- #


# Fancy Ctrl+z
# https://github.com/mdumitru/fancy-ctrl-z
# Use CTRL+z to background and bringback Vim
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line -w
  else
    zle push-input -w
    zle clear-screen -w
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Centos Paste Service (https://paste.centos.org)
function pasteit() {
  local file_path=$1
  local private=1
  local author_name="Bad3r"
  local syntax_highlighting="text"
  local response=""
  local paste_id=""

  # Parse command-line arguments
  if [[ $# -gt 1 ]]; then
    while [[ $# -gt 0 ]]; do
      case $1 in
        -p|--public)
          private=0
          shift ;;
        -a|--author)
          author_name=$2
          shift 2 ;;
        -l|--lang)
          if [[ $2 =~ ^(text|html5|css|javascript|php|python|ruby|lua|bash|erlang|go|c|cpp|diff|latex|sql|xml|0|4cs|6502acme|6502kickass|6502tasm|68000devpac|abap|actionscript|actionscript3|ada|aimms|algol68|apache|applescript|apt_sources|arm|asm|asymptote|asp|autoconf|autohotkey|autoit|avisynth|awk|bascomavr|basic4gl|bbcode|bf|bibtex|blitzbasic|bnf|boo|c_loadrunner|c_mac|c_winapi|caddcl|cadlisp|cfdg|cfm|chaiscript|chapel|cil|clojure|cmake|cobol|coffeescript|cpp-winapi|csharp|cuesheet|d|dart|dcs|dcl|dcpu16|delphi|div|dos|dot|e|ecmascript|eiffel|email|epc|euphoria|ezt|f1|falcon|fo|fortran|freebasic|freeswitch|fsharp|gambas|gdb|genero|genie|gettext|glsl|gml|gnuplot|groovy|gwbasic|haskell|haxe|hicest|hq9plus|html4strict|icon|idl|ini|inno|intercal|io|ispfpanel|j|java|java5|jcl|jquery|klonec|klonecpp|kotlin|lb|ldif|lisp|llvm|locobasic|logcat|logtalk|lolcode|lotusformulas|lotusscript|lscript|lsl2|m68k|magiksf|make|mapbasic|matlab|mirc|mmix|modula2|modula3|mpasm|mxml|mysql|nagios|netrexx|newlisp|nginx|nimrod|nsis|oberon2|objc|objeck|ocaml|octave|oobas|oorexx|oracle11|oracle8|oxygene|oz|parasail|parigp|pascal|pcre|per|perl|perl6|pf|pic16|pike|pixelbender|pli|plsql|postgresql|postscript|povray|powerbuilder|powershell|proftpd|progress|prolog|properties|providex|purebasic|pys60|q|qbasic|qml|racket|rails|rbs|rebol|reg|rexx|robots|rpmspec|rsplus|rust|sas|scala|scheme|scilab|scl|sdlbasic|smalltalk|smarty|spark|sparql|standardml|stonescript|systemverilog|tcl|teraterm|thinbasic|tsql|typoscript|unicon|uscript|upc|urbi|vala|vb|vbnet|vbscript|vedit|verilog|vhdl|vim|visualfoxpro|visualprolog|whitespace|whois|winbatch|xbasic|xorg_conf|xpp|yaml|z80|zxbasic)$ ]]; then
                syntax_highlighting=$2
          else
            echo "Error: Unsupported language. Possible values: text, html5, css, javascript, php, python, ruby, lua, bash, erlang, go, c, cpp, diff, latex, sql, xml, 0, 4cs, 6502acme, 6502kickass, 6502tasm, 68000devpac, abap, actionscript, actionscript3, ada, aimms, algol68, apache, applescript, apt_sources, arm, asm, asymptote, asp, autoconf, autohotkey, autoit, avisynth, awk, bascomavr, basic4gl, bbcode, bf, bibtex, blitzbasic, bnf, boo, c_loadrunner, c_mac, c_winapi, caddcl, cadlisp, cfdg, cfm, chaiscript, chapel, cil, clojure, cmake, cobol, coffeescript, cpp-winapi, csharp, cuesheet, d, dart, dcs, dcl, dcpu16, delphi, div, dos, dot, e, ecmascript, eiffel, email, epc, euphoria, ezt, f1, falcon, fo, fortran, freebasic, freeswitch, fsharp, gambas, gdb, genero, genie, gettext, glsl, gml, gnuplot, groovy, gwbasic, haskell, haxe, hicest, hq9plus, html4strict, icon, idl, ini, inno, intercal, io, ispfpanel, j, java, java5, jcl, jquery, klonec, klonecpp, kotlin, lb, ldif, lisp, llvm, locobasic, logcat, logtalk, lolcode, lotusformulas, lotusscript, lscript, lsl2, m68k, magiksf, make, mapbasic, matlab, mirc, mmix, modula2, modula3, mpasm, mxml, mysql, nagios, netrexx, newlisp, nginx, nimrod, nsis, oberon2, objc, objeck, ocaml, octave, oobas, oorexx, oracle11, oracle8, oxygene, oz, parasail, parigp, pascal, pcre, per, perl, perl6, pf, pic16, pike, pixelbender, pli, plsql, postgresql, postscript, povray, powerbuilder, powershell, proftpd, progress, prolog, properties, providex, purebasic, pys60, q, qbasic, qml, racket, rails, rbs, rebol, reg, rexx, robots, rpmspec, rsplus, rust, sas, scala, scheme, scilab, scl, sdlbasic, smalltalk, smarty, spark, sparql, standardml, stonescript, systemverilog, tcl, teraterm, thinbasic, tsql, typoscript, unicon, uscript, upc, urbi, vala, vb, vbnet, vbscript, vedit, verilog, vhdl, vim, visualfoxpro, visualprolog, whitespace, whois, winbatch, xbasic, xorg_conf, xpp, yaml, z80, zxbasic"
            return 1
          fi
          shift 2 ;;
        *)
          echo "Unknown option: $1"
          return 1 ;;
      esac
    done
  fi

  local api_url="https://paste.opensuse.org/api/create"

  response=$(curl -s -d "private=${private}" -d "name=${author_name}" --data-urlencode -d "${syntax_highlighting}=@${file_path}" ${api_url})

  paste_id=$(echo ${"response"} | sed -n 's/.*https:\/\/paste.centos.org\/view\/\(.*\)/\1/p')

  if [[ -n $paste_id ]]; then
    echo "File uploaded successfully. Paste URL: https://paste.centos.org/view/${paste_id}"
  else
    echo "Failed to upload file. Error: ${response}"
  fi
}

# mktmpdircd [base_dir]
# use custom directory (defaults to $TMPDIR env var or /tmp if not set) 
# Create and cd into a temp directory under $base_dir (or $TMPDIR/ /tmp if none),
# and clean it up on shell exit.
function mktmpdir() {
  local base_dir="${1:-${TMPDIR:-/tmp}}"
  local tmpdir

  tmpdir=$(mktemp -d --tmpdir="$base_dir") || {
    echo "mktemp failed (check that '$base_dir' exists and is writable)" >&2
    return 1
  }

  cd "$tmpdir" || return 1

  echo "[i] $tmpdir"
  echo "[!] (will be removed on shell exits)"

  # Clean up on shell exit
  trap 'rm -rf -- "$tmpdir"' EXIT
}


# Pacman

search_aur() {
    paru -Sl | awk '{print $2($4=="" ? "" : " *")}' | \
    sk --multi --preview 'paru -Si {1}' | \
    cut -d " " -f 1 | xargs -ro paru -S
}

ba_search() {
    pacman -Sgg | rg blackarch | cut -d ' ' -f2 | sort -u | fzf
}

# Reinitialize Pacman keys
packey() {
    local repos_to_check=(alhp cachyos blackarch)
    local active_repos=(archlinux)  # archlinux is always included

    # Check which repos are active in pacman.conf
    for repo in "${repos_to_check[@]}"; do
        case $repo in
            alhp)
                if grep -q "^\[core-x86-64-v3\]" /etc/pacman.conf; then
                    active_repos+=("$repo")
                fi
                ;;
            cachyos)
                if grep -q "^\[cachyos-" /etc/pacman.conf; then
                    active_repos+=("$repo")
                fi
                ;;
            blackarch)
                if grep -q "^\[blackarch\]" /etc/pacman.conf; then
                    active_repos+=("$repo")
                fi
                ;;
            endeavouros)
                if grep -q "^\[endeavouros\]" /etc/pacman.conf; then
                    active_repos+=("$repo")
                fi
                ;;
        esac
    done

    echo "${active_repos[@]}"

    sudo rm -rf /etc/pacman.d/gnupg && \
    sudo pacman-key --init && \
    sudo pacman-key --populate ${active_repos[@]}
}


pacnew() {
    # Check if a parameter is passed
    if [[ -z "$1" ]]; then
        echo "Usage: compare_pacnew <file>"
        return 1
    fi

    # Define the original file and the .pacnew file
    local file="$1"
    local pacnew="${file}.pacnew"

    # Check if the .pacnew file exists
    if [[ ! -f "$pacnew" ]]; then
        echo "No .pacnew file found for $file"
        return 1
    fi

    # Run the command
    sudo code --no-sandbox --user-data-dir="$HOME" "$file" "$pacnew"
}



# command_exists()
# Check if a command is available
# Usage: command_exists <command>
# Returns: 0 if the command is available, 1 otherwise
# Example:
# if command_exists nvim; then
#   echo "nvim is installed"
# else
#   echo "nvim is not installed"
# fi
#
# This function caches the result of the command check to avoid repeated calls
# to the `command -v` command.
#
# The cache is stored in the command_exists associative array
declare -A command_exists

command_exists() {
    local cmd="$1"

    if [[ -n "$command_exists[$cmd]" ]]; then
        return $command_exists[$cmd]
    fi

    if command -v "$cmd" &> /dev/null; then
        command_exists[$cmd]=0
    else 
        command_exists[$cmd]=1
    fi

    # if debug is true i.e 0 print debug message
    if [[ $DEBUG -eq 0 ]]; then
        printf "[DEBUG] command_exists[$cmd]=${command_exists[$cmd]}\n"
    fi
    
    return ${command_exists[$cmd]}
}