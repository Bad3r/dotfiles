# Check if a command is available with caching
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

    if [[ $DEBUG -eq 0 ]]; then
        printf "[DEBUG] command_exists[$cmd]=${command_exists[$cmd]}\n"
    fi
    
    return ${command_exists[$cmd]}
}