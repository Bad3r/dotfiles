# --------------------------------------------------------------------------- #
#*                            Lazy Loading System
# --------------------------------------------------------------------------- #
# This file provides functions to lazy-load tool configurations
# to improve shell startup time

# lazy_load_command()
# Create a wrapper function that loads the actual configuration on first use
# Usage: lazy_load_command <command> <config_file>
function lazy_load_command() {
    local cmd="$1"
    local config_file="$2"
    
    # Debug: check if cmd contains special characters
    if [[ "$cmd" =~ [^a-zA-Z0-9_-] ]]; then
        echo "Warning: lazy_load_command received invalid command name: '$cmd'" >&2
        return 1
    fi
    
    eval "
    $cmd() {
        unfunction $cmd
        source $config_file
        $cmd \"\$@\"
    }
    "
}

# lazy_load_alias()
# Create a wrapper alias that loads the actual configuration on first use
# Usage: lazy_load_alias <alias> <config_file>
function lazy_load_alias() {
    local alias_name="$1"
    local config_file="$2"
    
    alias $alias_name="unalias $alias_name; source $config_file; $alias_name"
}

# lazy_load_completion()
# Lazy load completion configurations
# Usage: lazy_load_completion <command> <config_file>
function lazy_load_completion() {
    local cmd="$1"
    local config_file="$2"
    
    eval "_lazy_load_${cmd}() {
        unfunction _lazy_load_${cmd}
        source $config_file
        # Re-trigger completion for current command
        _main_complete
    }"
    
    compdef _lazy_load_${cmd}=$cmd
}