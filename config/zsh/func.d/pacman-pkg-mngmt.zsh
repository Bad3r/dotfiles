# --------------------------------------------------------------------------- #
#*                            Pacman/Package Management
# --------------------------------------------------------------------------- #
#!/usr/bin/env zsh

aur_search() {
    paru -Sl | awk '{print $2($4=="" ? "" : " *")}' | \
    sk --multi --preview 'paru -Si {1}' | \
    cut -d " " -f 1 | xargs -ro paru -S
}

blackarch_search() {
    pacman -Sgg | rg blackarch | cut -d ' ' -f2 | sort -u | fzf
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

# --------------------------------------------------------------------------- #
#*                            Pacman/Package Management
# --------------------------------------------------------------------------- #
#!/usr/bin/env zsh

aur_search() {
    paru -Sl | awk '{print $2($4=="" ? "" : " *")}' | \
    sk --multi --preview 'paru -Si {1}' | \
    cut -d " " -f 1 | xargs -ro paru -S
}

blackarch_search() {
    pacman -Sgg | rg blackarch | cut -d ' ' -f2 | sort -u | fzf
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

    if (( $+commands[meld] )); then
        sudo meld "$file" "$pacnew"
    else
        echo "[!] Meld not installed. Using $DIFFPROG instead"
        echo "  -> Install meld: yay -S meld"
        sudo $DIFFPROG "$file" "$pacnew"
    fi
}


packey() {
    local -A repos=(
        [archlinux]='^\[core\]:archlinux-keyring'
        [alhp]='^\[core.*-x86-64-v[34]\]:alhp-keyring'
        [cachyos]='^\[cachyos:cachyos-keyring'
        [blackarch]='^\[blackarch\]:blackarch-keyring'
        [endeavouros]='^\[endeavouros\]:endeavouros-keyring'
        [chaotic-aur]='^\[chaotic-aur\]:chaotic-keyring'
        [artix]='^\[artix\]:artix-keyring'
    )

    local active_repos=()
    local keyring_pkgs=()
    local failed_repos=()

    echo "==> Identifying active repositories..."

    for repo data in ${(kv)repos}; do
        local pattern=${data%%:*}
        local keyring=${data#*:}
        
        if grep -qE "$pattern" /etc/pacman.conf 2>/dev/null; then
            echo "  -> ✅ $repo"
            active_repos+=($repo)
            keyring_pkgs+=($keyring)
        fi
    done

    echo ""
    echo "[!] WARNING: This will completely reinitialize your repos keyrings."
    echo "This operation will:"
    echo "  1. Backup current keyring to /tmp/pacman-gnupg-backup"
    echo "  2. Remove /etc/pacman.d/gnupg"
    echo "  3. Initialize new keyring"
    echo "  4. Populate keys for: ${active_repos[*]}"
    echo ""

    local backup_dir="/tmp/pacman-gnupg-backup"
    echo "==> Renaming /etc/pacman.d/gnupg -> $backup_dir..."
    sudo mv /etc/pacman.d/gnupg $backup_dir 2>/dev/null || {
        echo "WARNING: Could not create backup" >&2
        return 1
    }

    echo "==> Initializing new keyring..."
    sudo pacman-key --init || {
        echo "ERROR: Failed to initialize keyring" >&2
        echo "Restore with: sudo rm -rf /etc/pacman.d/gnupg && sudo mv $backup_dir /etc/pacman.d/gnupg" >&2
        return 1
    }

    echo "==> Populating keyrings..."
    for repo in ${active_repos[@]}; do
        echo "  -> Populating: $repo"
        sudo pacman-key --populate $repo 2>/dev/null || {
            echo "WARNING: Failed to populate $repo keyring" >&2
            failed_repos+=($repo)
        }
    done

    echo ""
    if (( ${#failed_repos} )); then
        echo "==> Keyring initialized with warnings:"
        echo "    Failed repositories: ${failed_repos[*]}"
        echo "    You may need to manually run: sudo pacman-key --populate ${failed_repos[*]}"
        echo "    Or check if these repositories are correctly configured"
    else
        echo "==> Keyring successfully reinitialized!"
    fi
    
    echo "Backup available at: $backup_dir"
    (( ${#failed_repos} )) && return 1
    return 0
}
