# Tool: File Manager Selection
# Desc: Set FILE_MANAGER based on available options

# Priority: nemo > thunar > dolphin > nautilus
if (( $+commands[nemo] )); then
    export FILE_MANAGER="nemo"
elif (( $+commands[thunar] )); then
    export FILE_MANAGER="thunar"
elif (( $+commands[dolphin] )); then
    export FILE_MANAGER="dolphin"
elif (( $+commands[nautilus] )); then
    export FILE_MANAGER="nautilus"
fi