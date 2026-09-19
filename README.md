# Dotfiles & Custom Scripts

## Current Setup Notes:
- Terminal:             `kitty`
- Icon Theme:           `Qogir-dark`
- Preferred Theme:       `GitHub Dark Dimmed`
- Font:                 `MonoLisa Variable`, `ttf-font-awesome`, `woff2-font-awesome`, `atkinson-hyperlegible-next`, `ttf-devicons`, `ttf-octicons`
- Power Management:     `xfce4-power-manager`, `power-profiles-daemon`
- Notification Daemon:  `dunst`
    - Startup handled by: `config/systemd/user/org.freedesktop.Notifications.service`
- Screenshot:           `flameshot`, `maim`
- Editor:               `nvim`
- diff viewer:          `kitty +kitten diff`, `meld` (GUI)
- Video Player:         `mpv`
- Image Viewer:         `nsxiv`, `feh`

- Document Viewer:      `zathura`
- Runner:               `rofi`
    - Run Script:       `bin/rofi_run -h`
    - Deps:
        - clipboard:    `rofi-greenclip` # Greenclip w/ image & blacklist support
        - calc:         `libqalculate`


## ZSH
Owned by Home Manager in the NixOS flake: [`modules/shell/zsh/`](https://github.com/Bad3r/nixos/tree/main/modules/shell/zsh) in `Bad3r/nixos`.
This repo links no zsh files.
