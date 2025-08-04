#---------------------------------------------------------------------------
# *                            Chromium
#---------------------------------------------------------------------------

if ! (( $+commands[chromium] )) && ! (( $+commands[ungoogled-chromium] )); then
    return
fi

# enable hardware acceleration
export CHROMIUM_FLAGS="--enable-features=VaapiVideoDecoder"
export CHROME_EXECUTABLE="ungoogled-chromium"
