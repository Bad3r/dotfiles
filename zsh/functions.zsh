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


# ---------------------------------------- #
# --------------- Functions -------------- #

# expand aliases 
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

# Toggles "sudo" before the current/previous command by pressing [ESC][ESC]
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


# ---------------------------------------- #
# ----------- Colored man pages ---------- #
# ---------------------------------------- #

if [[ "$OSTYPE" = solaris* ]]
then
	if [[ ! -x "$HOME/bin/nroff" ]]
	then
		mkdir -p "$HOME/bin"
		cat > "$HOME/bin/nroff" <<EOF
#!/bin/sh
if [ -n "\$_NROFF_U" -a "\$1,\$2,\$3" = "-u0,-Tlp,-man" ]; then
	shift
	exec /usr/bin/nroff -u\$_NROFF_U "\$@"
fi
#-- Some other invocation of nroff
exec /usr/bin/nroff "\$@"
EOF
		chmod +x "$HOME/bin/nroff"
	fi
fi

function colored() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		PAGER="${commands[less]:-$PAGER}" \
		_NROFF_U=1 \
		PATH="$HOME/bin:$PATH" \
			"$@"
}

function man() {
	colored man "$@"
}

