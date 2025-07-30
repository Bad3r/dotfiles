#!/bin/sh

# window_utils.sh: A library to calculate window position and size for i3/sway

# Configuration for scaling and gaps
SCREEN_SCALE=1.0
TOPBAR_HEIGHT=29
TOP_GAP=6
BOTTOM_GAP=6
OUTER_GAP=4

# Function to parse primary monitor resolution and position
get_primary_monitor_info() {
    xrandr --query | awk '/ connected primary/ {print $4}'
}

# Function to calculate floating-point values
calculate() {
    echo "$1" | bc
}

# Function to round to integers
calculate_int() {
    echo "$1" | bc | awk '{printf "%.0f\n", $1}'
}

# Function to calculate window size and position
calculate_window_geometry() {
    # Get primary monitor resolution and position
    local primary_monitor
    primary_monitor=$(get_primary_monitor_info)

    if [ -z "$primary_monitor" ]; then
        echo "Error: No primary monitor detected!" >&2
        exit 1
    fi

    # Extract resolution and offset
    local screen_width screen_height screen_offset_x screen_offset_y aspect_ratio
    screen_width=$(echo "$primary_monitor" | cut -d'x' -f1)
    screen_height=$(echo "$primary_monitor" | cut -d'x' -f2 | cut -d'+' -f1)
    screen_offset_x=$(echo "$primary_monitor" | awk -F '+' '{print $2}')
    screen_offset_y=$(echo "$primary_monitor" | awk -F '+' '{print $3}')

    # Detect if the monitor matches the specific wide monitor configuration
    if [ "$screen_width" -eq 3440 ] && [ "$screen_height" -eq 1440 ] && [ "$screen_offset_x" -eq 1440 ] && [ "$screen_offset_y" -eq 651 ]; then
        # Use the corrected custom values for the specific wide monitor
        export TARGET_WIDTH=1134
        export TARGET_HEIGHT=1389
        export TARGET_X=2593
        export TARGET_Y=691
        return
    fi

    # Calculate aspect ratio to determine if it's a wide monitor
    aspect_ratio=$(calculate "$screen_width / $screen_height")

    # Adjust dimensions by scale factor
    local scaled_width scaled_height
    scaled_width=$(calculate_int "$screen_width * $SCREEN_SCALE")
    scaled_height=$(calculate_int "$screen_height * $SCREEN_SCALE")

    # Calculate window width based on monitor aspect ratio
    local target_width
    if [ "$(echo "$aspect_ratio >= 2.0" | bc)" -eq 1 ]; then
        target_width=$(calculate_int "$scaled_width / 3 - $OUTER_GAP")
    else
        target_width=$(calculate_int "$scaled_width / 2 - $OUTER_GAP")
    fi

    # Calculate target height and position
    local target_height target_x target_y
    target_height=$(calculate_int "$scaled_height - $TOPBAR_HEIGHT - $TOP_GAP - $BOTTOM_GAP")
    target_x=$(calculate_int "$screen_offset_x + $scaled_width - $target_width")
    target_y=$(calculate_int "$screen_offset_y + $TOPBAR_HEIGHT + $TOP_GAP")

    # Export results as variables
    export TARGET_WIDTH="$target_width"
    export TARGET_HEIGHT="$target_height"
    export TARGET_X="$target_x"
    export TARGET_Y="$target_y"
}
