# --------------------------------------------------------------------------- #
#                                Miscellaneous                                #
# --------------------------------------------------------------------------- #

# If command is a path, cd into it
setopt auto_cd

# remove trailing slash when tab-completing
setopt auto_remove_slash

# Resolve symbolic links
setopt chase_links

# Prevents accidantally overwriting a file
# use !< to force writing to the file
setopt noclobber

# Try to correct spelling of commands
setopt correct

# Report command stats if time is >
REPORTTIME=5
