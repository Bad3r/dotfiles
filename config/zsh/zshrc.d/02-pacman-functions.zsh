# --------------------------------------------------------------------------- #
#*                            Pacman/Package Management
# --------------------------------------------------------------------------- #

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
    if [[ -z "$1" ]]; then
        echo "Usage: compare_pacnew <file>"
        return 1
    fi

    local file="$1"
    local pacnew="${file}.pacnew"

    if [[ ! -f "$pacnew" ]]; then
        echo "No .pacnew file found for $file"
        return 1
    fi

    sudo code --no-sandbox --user-data-dir="$HOME" "$file" "$pacnew"
}