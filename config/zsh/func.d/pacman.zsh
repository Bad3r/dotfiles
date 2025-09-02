# https://wiki.archlinux.org/title/zsh#pacman_-F_%22command_not_found%22_handler
function command_not_found_handler {
    # Prevent this handler from running during startup/eval contexts
    [[ "$ZSH_EVAL_CONTEXT" == *"eval"* ]] && return 127
    
    # Also skip if we're in a function definition context
    [[ "$ZSH_EVAL_CONTEXT" == *"funcdef"* ]] && return 127
    
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    
    # Check if pacman exists before trying to use it
    if ! command -v pacman >/dev/null 2>&1 || [[ ! -x /usr/bin/pacman ]]; then
        return 127
    fi
    
    local entries=(
        ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
    )
    if (( ${#entries[@]} ))
    then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}"
        do
            # (repo package version file)
            local fields=(
                ${(0)entry}
            )
            if [[ "$pkg" != "${fields[2]}" ]]
            then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
}
