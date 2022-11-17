
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
alias yeet='paru -Rns'

# ---------------------------------------- #
# --------------- BlackArch -------------- #
# ---------------------------------------- #
# Fzf & ripgrep https://github.com/BurntSushi/ripgrep
alias -g ba_search="pacman -Sgg |rg blackarch |cut -d ' ' -f2 |sort -u | fzf"



# ---------------------------------------- #
# ------------ Change Defaults ----------- #
# ---------------------------------------- #

# undoller ❯ $ cmd --> ❯ cmd
alias \$=''
alias vi="$EDITOR"
alias vim="$EDITOR"
alias ghc="ghc -dynamic"
alias gcc="gcc -ggdb -std=c99 -Wall -Wextra -pedantic"
alias mv="mv -iv"
alias ip='ip -color=auto'
alias dmesg='dmesg --color=always'
alias rm='rm -v'
# Change layout of lsblk to include FSTYPE,UUID and remove MAJ:MIN, RM, and RO collumns.
alias lsblk='lsblk -o NAME,FSTYPE,SIZE,TYPE,UUID,MOUNTPOINT'
alias nmap='sudo -E nmap'
alias emacs='emacs -nw'

#  bat https://github.com/sharkdp/bat
if (( $+commands[bat] )); then                             
    alias catt="bat -pp"
fi


# Fast access to files and scripts

alias -g zshrc="$EDITOR ~/.zshrc"
alias -g xresources="$EDITOR ~/.Xresources"
alias -g i3conf="$EDITOR ~/.i3/config"




# ---------------------------------------- #
# ------------- Miscellaneous ------------ #
# ---------------------------------------- #

## super user alias
alias _='sudo '
alias -g copy="xclip -o | xclip -selection clipboard -i"   # Copy selection https://wiki.archlinux.org/index.php/Copying_text_from_a_terminal
alias cpy="xsel --clipboard"
alias -g paste="xclip -o -sel clip"                        # paste: to terminal, file: paste > <file>
alias hex="hyx"                                            # CLI hex editor
alias fetch="fastfetch"                                    # Show system information.
alias neofetch="fastfetch"
alias ducks='du -cms * | sort -rn | head -11'              # list the largest 10 files in a dir replace m with k for kb
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
alias k-diff="kitty +kitten diff"
alias k-img="kitty +kitten icat"
alias k-grep-url="kitty +kitten hyperlinked_grep -f"
alias input="sudo input-remapper-service & input-remapper-control --command autoload"


# net
alias tb="nc termbin.com 9999"                             # Upload files to netcat-based pastebin. 
alias wifi="nmcli dev wifi"
alias yeet="curl parrot.live"                              # yeet
alias ipa='ip a'
alias ipeth='ip a show enp0s31f6'
alias ipwlan='ip a show wlan0'
alias ipia='ip a show wgpia0'
alias iptun='ip a show tun0'
alias wtfip='curlie wtfismyip.com/json'
alias hx='helix'