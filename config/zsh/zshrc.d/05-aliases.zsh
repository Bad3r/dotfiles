: <<'BDR'

                                    /   \                                      
                            )      ((   ))     (                               
                           /|\      ))_((     /|\                              
       (@)                / | \    (/\|/\)   / | \                 (@)         
       |-|---------------/--|-voV---\`|'/--Vov-|--\----------------|-|         
       |-|                    '^`   (o o)  '^`                     | |         
       | |                          `\Y/'                          |-|         
       |-|                                                         | |         
       | |               File...:    .config/zsh/aliases.zsh       |-|         
       |-|               twitter:    @0xBader                      | |         
       | |               website:    SecBytes.net                  |-|         
       | |_________________________________________________________| |         
       |-|/`       l   /\ /         ( (       \ /\   l           `\|-|         
       (@)         l /   V           \ \       V   \ l             (@)         
                   l/                _) )_          \I                         
                                     `\ /' 

BDR



# ---------------------------------------- #
# -------------- Arch Linux -------------- #
# ---------------------------------------- #

alias spm="sudo pacman --color=always -S"
alias yya="yay"
alias yy="yay"
alias ya="yay"
alias up="yay -Syu"
alias upc="yay -Syu --noconfirm"
alias yayskip='yay -S --mflags --skipinteg'
alias packey="sudo rm -rf /etc/pacman.d/gnupg && sudo pacman-key --init && sudo pacman-key --populate archlinux"
# Search AUR packages using Paru and fzf
alias search_aur="paru -Sl | awk '{print \$2(\$4==\"\" ? \"\" : \" *\")}' | sk --multi --preview 'paru -Si {1}' | cut -d \" \" -f 1 | xargs -ro paru -S"
alias chx="sudo chmod +x"
alias conf='chezmoi edit --apply'

# ---------------------------------------- #
# --------------- BlackArch -------------- #
# ---------------------------------------- #
# Fzf & ripgrep https://github.com/BurntSushi/ripgrep
alias -g ba_search="pacman -Sgg |rg blackarch |cut -d ' ' -f2 |sort -u | fzf"



# ---------------------------------------- #
# ------------ Change Defaults ----------- #
# ---------------------------------------- #
alias -g grep="grep --color=always"
# undoller ❯ $ cmd --> ❯ cmd
alias \$=''
alias vi="$EDITOR"
alias vim="$EDITOR"
alias dir="dir --color=auto"
alias vdir="vdir --color=auto"
alias ghc="ghc -dynamic"
alias gcc="gcc -ggdb -std=c99 -Wall -Wextra -pedantic"
alias mv="mv -iv"
alias ip='ip -color=auto'
alias dmesg='dmesg --color=always'
alias mkdir='mkdir -vp'
alias rm='rm -v'
# Change layout of lsblk to include FSTYPE,UUID and remove MAJ:MIN, RM, and RO collumns.
alias lsblk='lsblk -o NAME,FSTYPE,SIZE,TYPE,UUID,MOUNTPOINT'
alias nmap='sudo -E nmap'
alias emacs='emacs -nw'

# Replace cat with bat https://github.com/sharkdp/bat
if (( $+commands[bat] )); then                             
    alias ca="bat -pp"
fi


# Replace ls with exa https://github.com/ogham/exa
if (( $+commands[exa] )); then
    alias -g la="exa -alhg --git --icons"
    alias -g ll="exa -lhaF --git --icons"
    alias -g ls="exa --icons"
    alias -g tree="exa --tree --icons --level=1"
fi

# Fast access to files and scripts

alias -g zshrc="$EDITOR ~/.zshrc"
alias -g xresources="$EDITOR ~/.Xresources"
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
alias giturl="git remote show origin"
alias repo_add="mr register"
alias repo_update="mr update"                              # https://myrepos.branchable.com/

# ---------------------------------------- #
# ------------- Miscellaneous ------------ #
# ---------------------------------------- #

alias -g dis="xrandr --output DP-0 --off --output DP-1 --off --output HDMI-0 --mode 1920x1080 --pos 1954x0 --rotate normal --output eDP-1-1 --mode 1920x1080 --pos 0x0 --rotate normal"
alias -g undis="killall intel-virtual-output"
alias -g cwal="chameleon -i $HOME/Pictures/Pictures/"      # https://github.com/GideonWolfe/Chameleon
alias -g copy="xclip -o | xclip -selection clipboard -i"   # Copy selection https://wiki.archlinux.org/index.php/Copying_text_from_a_terminal
alias cpy="xsel --clipboard"
alias -g paste="xclip -o -sel clip"                        # paste: to terminal, file: paste > <file>
alias tb="nc termbin.com 9999"                             # Upload files to netcat-based pastebin. 
alias hex="hyx"                                            # CLI hex editor
alias fetch="neofetch"                                     # Show system information.
alias wifi="nmcli dev wifi"
alias yeet="curl parrot.live"                              # yeet
alias lzd="lazydocker"     
alias ducks='du -cms * | sort -rn | head -11'              # list the largest 10 files in a dir replace m with k for kb
alias ipa='ip a'
alias ipeth='ip a show enp0s31f6'
alias ipwlan='ip a show wlan0'
alias ipia='ip a show wgpia0'
alias iptun='ip a show tun0'
alias wtfip='curlie wtfismyip.com/json'
alias cls="clear; tree"
alias cl="clear"
alias c="clear"
alias clr="clear"
alias todol="todoist --namespace --project-namespace list | fzf --preview 'todoist show {1}' | cut -d ' ' -f 1 | tr '\n' ' '"
alias vs='vscodium'
alias vialias="$EDITOR ~/.config/zsh/zshrc.d/05-aliases.zsh"
alias :q='exit'
alias q='exit'
alias psf="ps -ef | grep --color=always"
alias tl="tldr --list | fzf --preview 'tldr {} --color always' | xargs tldr"
alias sx='nsxiv'
alias sxiv="nsxiv"
alias e="emacs -nw"
alias d="kitty +kitten diff"
alias img="kitty +kitten icat"
alias grep_url="kitty +kitten hyperlinked_grep -f"
alias input="sudo input-remapper-service & input-remapper-control --command autoload"

# Valiases
alias camid='f() { vtoolbox device.lookup -s $1 | jq -r ".cameras[0].cameraId" | xsel --clipboard};f'
