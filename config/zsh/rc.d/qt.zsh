#---------------------------------------------------------------------------
# *                            QT
#---------------------------------------------------------------------------

if ! (( $+commands[qt6ct] )) && ! (( $+commands[qmake] )); then
    return
fi

# QT
export QT_SELECT=6
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_QPA_PLATFORMTHEME="qt6ct"
export QT_QPA_PLATFORM_PLUGIN_PATH="/usr/lib/qt/plugins"