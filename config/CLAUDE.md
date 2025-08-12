# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the configuration directory within a comprehensive Linux dotfiles repository. It contains application configurations following the XDG Base Directory specification and is managed via dotbot for symlink deployment.

## Common Commands

### Configuration Management
```bash
# Deploy/update all configurations via dotbot
cd ~/dotfiles && ./z-install-dots

# Link Electron app configs (selective linking)
cd ~/dotfiles && ./link_conf.sh

# Update all system packages and configurations
topgrade
```

### Testing Configuration Changes

#### i3 Window Manager
```bash
# Reload i3 configuration
i3-msg reload

# Test i3 configuration for errors
i3 -C -c ~/.config/i3/config

# Test toggle scripts
~/.config/i3/scripts/toggle_logseq.sh
~/.config/i3/scripts/toggle_obsidian.sh
```

#### Zsh
```bash
# Reload configuration
source ~/.zshenv && source $ZDOTDIR/.zshrc

# Profile startup performance
$ZDOTDIR/profile-startup.sh

# Test specific configuration
source $ZDOTDIR/rc.d/toolname.zsh
```

#### Neovim
```bash
# Update plugins
nvim -c "Lazy update" -c "qa"

# Check configuration health
nvim -c "checkhealth"
```

#### Dunst Notifications
```bash
# Restart notification daemon
systemctl --user restart org.freedesktop.Notifications.service

# Reload configuration
killall dunst && dunst &
```

### System Services
```bash
# Reload user systemd services
systemctl --user daemon-reload

# Check Claude automation timer
systemctl --user status claude_reset.timer
systemctl --user list-timers claude_reset.timer
```

## Architecture

### Directory Structure
- **dunst/** - Notification daemon configuration
- **i3/** - i3 window manager with custom scripts for window management
- **kitty/** - Terminal emulator with theme configurations
- **nvim/** - Neovim configuration with lazy.nvim plugin manager
- **qBittorrent/** - Torrent client configuration and theme
- **rofi/** - Application launcher and menu system
- **systemd/user/** - User systemd services and timers
- **zsh/** - Modular Zsh configuration (see zsh/CLAUDE.md for details)
- **JetBrains/** - IDE configurations and activation tools
- **VSCodium/** - Code editor settings
- **topgrade.d/** - System update automation configuration

### Key Configuration Patterns

#### i3 Window Manager Scripts
Toggle scripts in `i3/scripts/` follow a consistent pattern:
```bash
# Check if running → kill if yes, launch if no
pgrep -x appname && pkill appname || appname
```

#### Service Management
Custom services are defined in `systemd/user/`:
- `claude_reset.service` + `claude_reset.timer` - Claude automation
- `org.freedesktop.Notifications.service` - Dunst startup

#### Theme Consistency
Applications use GitHub Dark Dimmed theme where available:
- kitty: `GitHub_Dark_Dimmed.conf`
- rofi: `themes/github_dark_dimmed.rasi`
- qBittorrent: Custom dark theme

## Application-Specific Notes

### i3 Window Manager
- Mod key: Super/Windows key ($Mod)
- Config: `i3/config`
- Scripts: `i3/scripts/` for utilities
- Keybindings defined with `bindsym`
- Status bar: i3blocks with custom scripts

### Kitty Terminal
- Main config: `kitty/kitty.conf`
- Current theme symlinked to `current-theme.conf`
- Supports image preview and diff viewing

### Rofi
- Config: `rofi/config.rasi`
- Custom menus: powermenu, keyhint
- Launcher script: `~/dotfiles/bin/rofi_run`

### Zsh
See `zsh/CLAUDE.md` for detailed Zsh configuration documentation.

### Neovim
See `nvim/CLAUDE.md` for Neovim-specific documentation.

## Testing Patterns

### Configuration Validation
```bash
# Test i3 config without applying
i3 -C -c config/i3/config

# Test Zsh syntax
zsh -n config/zsh/**/*.zsh

# Test systemd service syntax
systemd-analyze verify --user config/systemd/user/*.service
```

### Isolated Testing
```bash
# Test configuration in isolation
cp config/app/config config/app/config.test
# Edit config.test
app --config config/app/config.test
```

## Important Files

### Parent Repository
- `~/dotfiles/z-install.conf.yml` - Dotbot symlink configuration
- `~/dotfiles/z-install-dots` - Installation script
- `~/dotfiles/link_conf.sh` - Electron app config linker

### This Directory
- `zsh/3rd_party_tools.md` - External tool dependencies
- `zsh/optimal_packages.md` - Recommended packages
- `topgrade.d/topgrade.toml` - Update automation settings

## Troubleshooting

### Missing Commands
Check `zsh/3rd_party_tools.md` for required tools. Install with:
```bash
# Arch Linux
sudo pacman -S package-name
yay -S aur-package-name
```

### Service Issues
```bash
# Check service logs
journalctl --user -u service-name -n 50

# Debug timer schedules
systemctl --user list-timers --all
```

### Configuration Not Applied
```bash
# Verify symlinks
ls -la ~/.config/ | grep " -> "

# Re-run dotbot
cd ~/dotfiles && ./z-install-dots
```

## Security Notes

- JetBrains directory contains activation tools - handle with care
- Weather scripts may contain API keys - check before committing
- qBittorrent.conf may have user-specific paths
- Review for hardcoded `/home/odd/` paths before sharing