#---------------------------------------------------------------------------
# *                            Grep Configuration
#---------------------------------------------------------------------------

if ! (( $+commands[grep] )); then
    return
fi

# _grep()
# Description: A wrapper function for grep that sets default color and exclude directories
# Usage: _grep [options] [pattern] [file]
# Example: _grep "error" *
# Returns: The output of grep with color and excludes the defined directories as well as case insensitive
function _grep() {
    local color="--color=always"
    local exclude_dirs="--exclude-dir={.git,.svn,.hg,.bzr,CVS,.idea,.tox,node_modules,__pycache__,.pytest_cache,.mypy_cache}"
    command grep $color $exclude_dirs -i "$@"
}


# Main grep aliases using the function
alias grep='_grep'
alias egrep='_grep -E'
alias fgrep='_grep -F'

# Useful grep shortcuts
alias grepi='_grep -i'                    # Case insensitive
alias grepr='_grep -r'                    # Recursive
alias grepri='_grep -ri'                  # Recursive + case insensitive
alias grepn='_grep -n'                    # Show line numbers
alias grepv='_grep -v'                    # Invert match
alias grepc='_grep -c'                    # Count matches
alias grepl='_grep -l'                    # Files with matches only
alias grepL='_grep -L'                    # Files without matches
alias grepw='_grep -w'                    # Whole words only
alias grepx='_grep -x'                    # Whole lines only

# Advanced combinations
alias greprin='_grep -rin'                # Recursive + case insensitive + line numbers
alias greprnw='_grep -rnw'                # Recursive + line numbers + whole words

# Context greps
alias grep1='_grep -C1'                   # 1 line context
alias grep3='_grep -C3'                   # 3 lines context
alias grep5='_grep -C5'                   # 5 lines context

# Binary file handling
alias grepb='_grep -a'                    # Treat binary as text
alias grepI='_grep -I'                    # Skip binary files

# System grep functions
function psgrep() { ps aux | _grep -v grep | _grep "$@"; }
alias psf="psgrep"
function portgrep() { sudo ss -HQtulnp | _grep "$@"; }
function hgrep() { history | _grep "$@"; }
function envgrep() { env | _grep "$@"; }

# Pattern extraction functions
function gip() { _grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" "$@"; }  # IPs
function gemail() { _grep -oE "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b" "$@"; }  # Emails
function gurl() { _grep -oE "https?://[^\s]+" "$@"; }  # URLs
function gphone() { _grep -oE "\b[0-9]{3}[-.]?[0-9]{3}[-.]?[0-9]{4}\b" "$@"; }  # Phone numbers

# File type specific greps
function gpy() { _grep -r --include="*.py" "$@"; }      # Python files
function gjs() { _grep -r --include="*.js" "$@"; }      # JavaScript files
function gcss() { _grep -r --include="*.css" "$@"; }    # CSS files
function ghtml() { _grep -r --include="*.html" "$@"; }  # HTML files
function gjson() { _grep -r --include="*.json" "$@"; }  # JSON files
function gxml() { _grep -r --include="*.xml" "$@"; }    # XML files
function gyml() { _grep -r --include="*.yml" --include="*.yaml" "$@"; }  # YAML files
function gconf() { _grep -r --include="*.conf" --include="*.config" "$@"; }  # Config files
function glog() { _grep -r --include="*.log" "$@"; }    # Log files

# Development shortcuts
function gtodo() { _grep -rn "TODO\|FIXME\|HACK\|XXX\|BUG" "$@"; }  # Find code comments
function gfunc() { _grep -rn "function\|def\|class" "$@"; }         # Find function definitions
function gimport() { _grep -rn "import\|require\|include" "$@"; }   # Find imports/includes
function gerr() { _grep -i "error\|warn\|fail\|exception" "$@"; }   # Find error patterns

