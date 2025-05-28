#---------------------------------------------------------------------------
# *                            Ripgrep
#---------------------------------------------------------------------------

if command_exists rg; then
    alias rgh='rg --hidden'                  # Include hidden files
    alias rgz='rg --search-zip'              # Search in compressed files
    alias rgi='rg --ignore-case'             # Case insensitive
    alias rgf='rg --files'                   # List files that would be searched
    alias rgt='rg --type-list'               # Show available file types
    alias rgp='rg --pretty'                  # Pretty output with colors
    alias rgj='rg --json'                    # JSON output
    alias rgc='rg --count'                   # Count matches per file
    alias rgl='rg --files-with-matches'      # Files with matches only
    alias rgL='rg --files-without-match'     # Files without matches
fi