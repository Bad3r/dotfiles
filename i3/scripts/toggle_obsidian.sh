#!/bin/sh

# source window utils lib to calculate window size and position
. "$HOME/bin/window_utils.sh"

# Calculate the window geometry
calculate_window_geometry

# Check if Obsidian is running
if ! pgrep -fl '/usr/lib/obsidian/app.asar' >/dev/null; then
    notify-send "Info" "Starting Obsidian.."
    i3-msg "exec --no-startup-id i3-scratchpad-show-or-create 'Obsidian' 'obsidian'"
    sleep 30
fi

# Run the i3 command with the calculated position and size
i3-msg "[class=\"obsidian\"] scratchpad show, move position ${TARGET_X}px ${TARGET_Y}px, resize set ${TARGET_WIDTH}px ${TARGET_HEIGHT}px"
