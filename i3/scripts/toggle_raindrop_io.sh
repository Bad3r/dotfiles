#!/bin/sh

# Configuration for topbar and gap sizes
TOPBAR_HEIGHT=29
TOP_GAP=6
BOTTOM_GAP=6
OUTER_GAP=4

# Cache directory and file
CACHE_DIR="/tmp/toggle_scripts"
CACHE_FILE="$CACHE_DIR/monitor_info"

# Create cache directory if it doesn't exist
mkdir -p "$CACHE_DIR"

# Check if the cache file exists and is not older than 24 hours
if [ ! -f "$CACHE_FILE" ] || [ "$(find "$CACHE_FILE" -mtime +1)" ]; then
    # Get the xrandr output once and cache it
    XRANDR_OUTPUT=$(xrandr --query)

    # Extract the primary monitor's name and resolution
    PRIMARY_MONITOR=$(echo "$XRANDR_OUTPUT" | awk '/ connected primary/ {print $1}')
    RESOLUTION=$(echo "$XRANDR_OUTPUT" | awk -v monitor="$PRIMARY_MONITOR" '
      $0 ~ "^" monitor " connected" { getline; print $1 }')

    # Cache the values in the file
    echo "$PRIMARY_MONITOR $RESOLUTION" > "$CACHE_FILE"
else
    # Read the cached monitor info
    read -r PRIMARY_MONITOR RESOLUTION < "$CACHE_FILE"
fi

# Check if PRIMARY_MONITOR or RESOLUTION is empty
if [ -z "$PRIMARY_MONITOR" ]; then
    notify-send "Warning" "No primary monitor set."
    exit 1
fi

if [ -z "$RESOLUTION" ]; then
    notify-send "Error" "Failed to get resolution for $PRIMARY_MONITOR."
    exit 1
fi


# Extract width and height from the resolution
SCREEN_WIDTH=${RESOLUTION%x*}
SCREEN_HEIGHT=${RESOLUTION#*x}

# Calculate the target size
TARGET_WIDTH=$((SCREEN_WIDTH / 2 - OUTER_GAP))
TARGET_HEIGHT=$((SCREEN_HEIGHT - TOPBAR_HEIGHT - TOP_GAP - BOTTOM_GAP))

# Calculate the target position
TARGET_X=$((SCREEN_WIDTH / 2))
TARGET_Y=$((TOPBAR_HEIGHT + TOP_GAP))

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
