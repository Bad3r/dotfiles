# Dotfiles & Custom Scripts

## Current Setup Notes:
- Terminal:             `kitty`
- Icon Theme:           `Qogir-dark`
- Prefered Theme:       `GitHub Dark Dimmed`
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
### File Tree
- `$HOME`
    - `.zshenv`
        - The first<sup>[1](#ref1)</sup> file read
- `$ZDOTDIR`
    - `env.d`
    - `func.d`
    - `rc.d` 
    - `zshrc.d`
Where `$ZDOTDIR` is set to `"${XDG_CONFIG_HOME:-$HOME/.config}/zsh"` in `$HOME/.zshenv`


### References
- <a name="ref1">1</a> [ZSH Documentation: 5.1 Startup/Shutdown Files](https://zsh.sourceforge.io/Doc/Release/Files.html#Files) 

