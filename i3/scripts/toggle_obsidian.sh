#!/bin/sh

# Screen scale factor
SCREEN_SCALE=1.0

# Configuration for topbar and gap sizes
TOPBAR_HEIGHT=29
TOP_GAP=6
BOTTOM_GAP=6
OUTER_GAP=4

# Cache directory and file
CACHE_DIR="/tmp/toggle_scripts"
SIZE_CACHE_FILE="$CACHE_DIR/size_info"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Function to run eva
run_eva() {
    eva "$1" | tr -d ',' # Remove commas from eva output
}

# Check if the size cache file exists, if so, read the cached size and position
if [ -f "$SIZE_CACHE_FILE" ]; then
    read -r TARGET_WIDTH TARGET_HEIGHT TARGET_X TARGET_Y <"$SIZE_CACHE_FILE"
else
    # Get the screen resolution using xrandr
    XRANDR_OUTPUT=$(xrandr --query)
    RESOLUTION=$(echo "$XRANDR_OUTPUT" | awk '/ connected primary/ {getline; print $1}')

    # Extract width and height from the resolution
    SCREEN_WIDTH=${RESOLUTION%x*}
    SCREEN_HEIGHT=${RESOLUTION#*x}

    # Adjust width and height based on the scale factor using eva
    SCALED_SCREEN_WIDTH=$(run_eva "$SCREEN_WIDTH * $SCREEN_SCALE" | tr -d ' ')
    SCALED_SCREEN_HEIGHT=$(run_eva "$SCREEN_HEIGHT * $SCREEN_SCALE" | tr -d ' ')

    # Break down complex eva calculations into smaller steps
    HALF_SCALED_SCREEN_WIDTH=$(run_eva "$SCALED_SCREEN_WIDTH / 2" | tr -d ' ')
    TARGET_WIDTH=$(run_eva "$HALF_SCALED_SCREEN_WIDTH - $OUTER_GAP" | tr -d ' ')
    TARGET_HEIGHT=$(run_eva "$SCALED_SCREEN_HEIGHT - $TOPBAR_HEIGHT - $TOP_GAP - $BOTTOM_GAP" | tr -d ' ')

    # Calculate the target position
    TARGET_X=$(run_eva "$HALF_SCALED_SCREEN_WIDTH" | tr -d ' ')
    TARGET_Y=$(run_eva "$TOPBAR_HEIGHT + $TOP_GAP" | tr -d ' ')

    # Trim decimal places for integer values
    TARGET_WIDTH=$(echo $TARGET_WIDTH | awk '{print int($1)}')
    TARGET_HEIGHT=$(echo $TARGET_HEIGHT | awk '{print int($1)}')
    TARGET_X=$(echo $TARGET_X | awk '{print int($1)}')
    TARGET_Y=$(echo $TARGET_Y | awk '{print int($1)}')

    # Cache the calculated size and position in the size cache file
    echo "$TARGET_WIDTH $TARGET_HEIGHT $TARGET_X $TARGET_Y" >"$SIZE_CACHE_FILE"
fi

# Check if Obsidian is running
if ! pgrep -fl '/usr/lib/obsidian/app.asar' >/dev/null; then
    notify-send "Info" "Starting Obsidian.."
    i3-msg "exec --no-startup-id i3-scratchpad-show-or-create 'Obsidian' 'obsidian'"
    sleep 30
fi

# Run the i3 command with the calculated position and size
i3-msg "[class=\"obsidian\"] scratchpad show, move position ${TARGET_X}px ${TARGET_Y}px, resize set ${TARGET_WIDTH}px ${TARGET_HEIGHT}px"
