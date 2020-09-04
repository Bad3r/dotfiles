: <<'///'
                             /   \
 _                   )      ((   ))     (
(@)                 /|\      ))_((     /|\
|-|                / | \    (/\|/\)   / | \                 (@) 
| | --------------/--|-voV---\`|'/--Vov-|--\----------------|-|
|-|                    '^`   (o o)  '^`                     | |
| |                          `\Y/'                          |-|
|-|                                                         | |
| |                 ~/.dotfiles/zsh/aliases.zsh             |-|
|-|                         @0xBad3r                        | |
| |                       SecBytes.net                      |-|
|_|_________________________________________________________| |
(@)         l   /\ /         ( (       \ /\   l           `\|-|
            l /   V           \ \       V   \ l             (@)
            l/                _) )_          \I
                              `\ /'

///



# ---------------------------------------- #
# -------------- Arch Linux -------------- #
# ---------------------------------------- #

alias spm="sudo pacman"
alias packey="sudo pacman-key --init && sudo pacman-key --populate archlinux && sudo pacman-key --refresh-keys && sudo pacman -Syy"
# ---------------------------------------- #
# --------------- BlackArch -------------- #
# ---------------------------------------- #

alias -g ba_search="pacman -Sgg |rg blackarch |cut -d ' ' -f2 |sort -u | fzf"  # Fzf & ripgrep https://github.com/BurntSushi/ripgrep



# ---------------------------------------- #
# ------------ Change Defaults ----------- #
# ---------------------------------------- #

alias grep="grep --color=always"
alias \$=''                                                # undoller ❯ $ cmd --> ❯ cmd
alias vi="$EDITOR"
alias vim="$EDITOR"
alias dir="dir --color=auto"
alias vdir="vdir --color=auto"
alias ghc="ghc -dynamic"
alias gcc="gcc -ggdb -std=c99 -Wall -Wextra -pedantic"
alias cp="cp -i"
alias mv="mv -i"
alias -g code="code-oss"                                   # Replace MS code with open source
alias -g vscode="code-oss"

if (( $+commands[bat] )); then                             # Replace cat with bat https://github.com/sharkdp/bat
    alias -g cat="bat"
fi

if (( $+commands[exa] )); then                             # Replace ls with exa https://github.com/ogham/exa
    alias -g la="exa -alh --git"
    alias -g ll="exa -lhaF --git"
    alias -g ls="exa"

    alias -g tree="exa --tree --level=1"

fi

# Fast access to files and scripts

alias -g zshrc="$EDITOR ~/.zshrc"
alias -g xresources= "$EDITOR ~/.Xresources"
alias -g i3conf="$EDITOR ~/.i3/config"


# ---------------------------------------- #
# ---------------- Docker ---------------- #
# ---------------------------------------- #

# Containers
alias dstart="sudo systemctl restart docker.service && systemctl status docker.service"
alias dps="docker ps"
alias dpsl='docker ps -l $*'
alias drm='docker rm'
alias dexec='docker exec'
alias dlog='docker logs'
alias dip='docker inspect --format "{{ .NetworkSettings.IPAddress }}" $*'
alias dstop_all='docker stop $* $(docker ps -q -f "status=running")'
alias drm_stopped='docker rm $* $(docker ps -q -f "status=exited")'
alias drmv_stopped='docker rm -v $* $(docker ps -q -f "status=exited")'
alias drm_all='docker rm $* $(docker ps -a -q)'
alias drmv_all='docker rm -v $* $(docker ps -a -q)'
alias dprune="docker system prune -a --volumes"

# Docker-compose
alias dcup="docker-compose up"
alias dcupb="docker-compose up --build"

# Volumes
alias dvls='docker volume ls $*'
alias dvrm_all='docker volume rm $(docker volume ls -q)'
alias dvrm_dang='docker volume rm $(docker volume ls -q -f "dangling=true")'

# ---------------------------------------- #
# ------------------ Git ----------------- #
# ---------------------------------------- #

if (( $+commands[hub] )); then                             # https://github.com/github/hub
    alias git="hub"                                           
    alias g="hub"
    alias gcm="hub commit -m "
    alias gcl="hub clone "
else
    alias g="git"
    alias gcm="git commit -m "
    alias gcl="git clone"
fi

alias repo_add="mr register"
alias repo_update="mr update"                              # https://myrepos.branchable.com/

# ---------------------------------------- #
# ------------- Miscellaneous ------------ #
# ---------------------------------------- #

alias -g dis="xrandr --output DP-0 --off --output DP-1 --off --output HDMI-0 --mode 1920x1080 --pos 1954x0 --rotate normal --output eDP-1-1 --mode 1920x1080 --pos 0x0 --rotate normal"
alias -g undis="killall intel-virtual-output"
alias -g cwal="chameleon -i $HOME/Pictures/Pictures/"      # https://github.com/GideonWolfe/Chameleon
alias -g copy="xclip -o | xclip -selection clipboard -i"   # Copy selection https://wiki.archlinux.org/index.php/Copying_text_from_a_terminal
alias -g paste="xclip -o -sel clip"                        # paste: to terminal, file: paste > <file>
alias tb="nc termbin.com 9999"                             # Upload files to netcat-based pastebin. 
alias hex="hyx"                                            # CLI hex editor
alias fetch="neofetch"                                     # Show system information.
alias wifi="nmcli dev wifi"
alias yeet="curl parrot.live"                              # yeet
alias lzd="lazydocker"     
alias ducks='du -cms * | sort -rn | head -11'              # list the largest 10 files in a dir replace m with k for kb
