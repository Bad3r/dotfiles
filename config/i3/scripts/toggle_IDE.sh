#!/bin/sh

# Source the library
. "$USR_LIB_DIR/window_utils"

# Calculate the window geometry
calculate_window_geometry

# Determine which application is running (PyCharm, VS Code, or Raindrop.io)
if pgrep -x -i "raindrop" >/dev/null; then
    APP_CLASS="Raindrop.io"
    APP_NAME="Raindrop.io"
elif pgrep -x -f "/usr/bin/pycharm-professional" >/dev/null; then
    APP_CLASS="pycharm"
    APP_NAME="PyCharm"
elif pgrep -x "rustrover" >/dev/null; then
    APP_CLASS="jetbrains-rustrover"
    APP_NAME="rustrover"
elif pgrep -x "rustrover" >/dev/null; then
    APP_CLASS="jetbrains-goland"
    APP_NAME="goland"
# Must be last
elif pgrep -x "code" >/dev/null; then
    APP_CLASS="Code"
    APP_NAME="VS Code"
else
    notify-send "Info" "Neither PyCharm nor Visual Studio Code is running."
    exit 1
fi

# Focus and resize the running application window
if ! i3-msg "[class=\"$APP_CLASS\"] scratchpad show, move position ${TARGET_X}px ${TARGET_Y}px, resize set ${TARGET_WIDTH}px ${TARGET_HEIGHT}px"; then
    notify-send "Error" "Failed to execute i3 command for $APP_NAME."
    exit 1
fi
