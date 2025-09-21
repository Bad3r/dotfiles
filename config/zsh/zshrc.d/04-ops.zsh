
#### Options section

# Auto correct mistakes
setopt correct

# Extended globbing. Allows using regular expressions with *
setopt extendedglob

# Keep '#' literal so flake targets like `nix run .#pkg` work
unsetopt interactivecomments

# Case insensitive globbing
setopt nocaseglob

# Array expension with parameters
setopt rcexpandparam

# Don't warn about running processes when exiting
setopt nocheckjobs

# Sort filenames numerically when it makes sense
setopt numericglobsort

# no beep
setopt nobeep

setopt pushd_ignore_dups
setopt pushdminus


# If command is a path, cd into it
setopt auto_cd

# automatically pushes (unique) directories visted into $dirstack
# to trace back use `$ popd`
# or `$ cd -5` to get back to the 5th most recent directory you've visited
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups

PS3="❯ "
d() {
    local dir
    select dir in $dirstack; break
    test "x$dir" != x && cd "$dir" || exit
}

# remove trailing slash when tab-completing
setopt auto_remove_slash

# Resolve symbolic links
setopt chase_links

# Prevents accidantally overwriting a file
# use !< to force writing to the file
setopt noclobber

# Try to correct spelling of commands
setopt correctall

# Report command stats if time is >
REPORTTIME=5
