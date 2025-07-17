# --------------------------------------------------------------------------- #
#*                            Utility Functions
# --------------------------------------------------------------------------- #

function set_win_title() {
  echo -ne "\033]0; $USER@$HOST:${PWD/$HOME/~} \007"
}
precmd_functions+=(set_win_title)

exec-zsh() {
  zle -I
  exec zsh <"$TTY"
}

zle -N exec-zsh
bindkey '^n' exec-zsh

# Search ArchWiki
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

mdv () {
  pandoc $1 | lynx -stdin
}

#---------------------------------------------------------------------------
# *                            Return zsh Statistics
#---------------------------------------------------------------------------

function zsh_stats() {
  fc -l 1 \
    | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]*100/count "% " a }' \
    | grep -v "./" | sort -nr | head -n 20 | column -c3 -s " " -t | nl
}

function run(){
  "$@" &>/dev/null &; disown
  exit 0
}

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

  trap 'rm -rf -- "$tmpdir"' EXIT
}