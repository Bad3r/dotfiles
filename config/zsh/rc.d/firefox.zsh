# Tool: Firefox and Variants
# Desc: Settings for Firefox, Zen Browser, and Firefox Developer Edition

# Check if any Firefox variant is installed
if ! (( $+commands[firefox] )) && \
   ! (( $+commands[zen-browser] )) && \
   ! (( $+commands[floorp] )) && \
   ! (( $+commands[firefox-developer-edition] )); then
    return
fi

# Enable WebRender compositor
export MOZ_WEBRENDER=1

# Enable hardware acceleration
export MOZ_X11_EGL=1

# Nvidia-specific settings (only if Nvidia driver is active)
if [[ -d /proc/driver/nvidia ]]; then
    # Firefox/Nvidia VAAPI settings
    export NVD_BACKEND=direct
    export LIBVA_DRIVER_NAME=nvidia
    export MOZ_DISABLE_RDD_SANDBOX=1
    
    # Disable DMABUF due to Nvidia issue
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
fi
