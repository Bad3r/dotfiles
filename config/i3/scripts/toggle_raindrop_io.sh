#!/bin/sh

# Source the library
. "$USR_LIB_DIR/window_utils"

# Calculate the window geometry
calculate_window_geometry

# Check if logseq is running 
if ! pgrep -x -i "raindrop" > /dev/null; then
    notify-send "Info" "Starting Raindrop.."
    i3-msg "exec --no-startup-id i3-scratchpad-show-or-create 'Raindrop' 'raindrop'"
    sleep 30
fi

# Run the i3 command with calculated position and size
if ! i3-msg "[class=\"Raindrop.io\"] scratchpad show, move position ${TARGET_X}px ${TARGET_Y}px, resize set ${TARGET_WIDTH}px ${TARGET_HEIGHT}px"; then
    notify-send "Error" "Failed to execute i3 command."
    exit 1
fi
