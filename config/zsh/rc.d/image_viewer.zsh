# Tool: Image Viewer Selection
# Desc: Set IMAGE based on available options

# Priority: nsxiv > sxiv > feh (fallback)
if (( $+commands[nsxiv] )); then
    export IMAGE="nsxiv"
elif (( $+commands[sxiv] )); then
    export IMAGE="sxiv"
else
    # Explicit fallback to feh
    export IMAGE="feh"
fi