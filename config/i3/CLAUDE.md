# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the i3 window manager configuration directory within a dotfiles repository. It contains the main i3 configuration, i3blocks status bar configuration, and various utility scripts for window management and system control.

## Common Commands

### Testing & Reloading Configuration
```bash
# Test configuration for syntax errors before applying
i3 -C -c /home/odd/dotfiles/config/i3/config

# Reload i3 configuration (Mod+Shift+c)
i3-msg reload

# Restart i3 in-place (Mod+Shift+r) 
i3-msg restart

# Test a specific toggle script
~/.config/i3/scripts/toggle_logseq.sh
~/.config/i3/scripts/toggle_obsidian.sh
```

### Status Bar Management
```bash
# Restart i3status-rs (the status bar)
killall i3status-rs && i3status-rs &

# Check i3status-rs logs if bar issues occur
journalctl --user -u i3status-rs -n 50
```

### Window Management
```bash
# Show/hide scratchpad window (Mod+z)
i3-msg scratchpad show

# Move window to scratchpad (Mod+Shift+z)
i3-msg move scratchpad

# List all windows
i3-msg -t get_tree | jq
```

## Architecture

### File Structure
- **config** - Main i3 configuration file
- **i3blocks.conf** - Status bar block configuration (currently using i3status-rs instead)
- **keybindings** - Human-readable keybinding reference
- **scripts/** - Utility scripts for various functions:
  - **toggle_*.sh** - Application toggle scripts using scratchpad
  - **i3lock-color-*.sh** - Screen locking themes
  - **volume_brightness.sh** - Media control script
  - Status bar scripts (battery, cpu_usage, memory, etc.)
- **workspace*.json** - Workspace layout files

### Key Configuration Details

#### Modifier Key
- **$Mod** = Mod4 (Super/Windows key)

#### Monitor Variables
- **$mon0** = "eDP-1-1" (laptop display)
- **$mon1** = "DP-1" (primary external)
- **$mon2** = "HDMI-0" (secondary external)

#### Toggle Script Pattern
All toggle scripts follow this pattern:
1. Source window_utils.sh for geometry calculation
2. Check if application is running with pgrep
3. Launch with i3-scratchpad-show-or-create if not running
4. Position window using i3-msg with calculated geometry

Example from toggle_logseq.sh:
```bash
. "$HOME/bin/window_utils.sh"
calculate_window_geometry
if ! pgrep -f logseq >/dev/null; then
    i3-msg "exec --no-startup-id i3-scratchpad-show-or-create 'Logseq' 'logseq'"
fi
i3-msg "[class=\"Logseq\"] scratchpad show, move position ${TARGET_X}px ${TARGET_Y}px"
```

#### Workspace Assignment
- Workspaces 1-6: Primary monitor ($mon1)
- Workspace 7: Laptop display ($mon0)
- Workspaces 8-10: Secondary monitor ($mon2)

### Core Keybindings
- **$Mod+Return** - Launch terminal (via exo-open)
- **$Mod+d** - Rofi application launcher
- **$Mod+x** - Rofi lock menu
- **$Mod+b** - Rofimoji (emoji picker)
- **$Mod+w** - Launch web browser
- **$Mod+q** - Kill focused window
- **$Mod+z** - Show scratchpad
- **$Mod+Shift+z** - Move to scratchpad

### Required Tools

Essential dependencies used by this configuration:
- **i3-msg** - i3 IPC interface
- **i3status-rs** - Status bar (replaces i3blocks)
- **rofi** - Application launcher and menus
- **pamixer** - Audio control
- **playerctl** - Media player control
- **xbacklight** - Backlight control
- **notify-send** - Desktop notifications
- **pgrep/pkill** - Process management
- **exo-open** - XDG application launcher
- **i3-scratchpad-show-or-create** - Scratchpad utility

## Development Patterns

### Adding New Toggle Scripts
1. Copy existing toggle script as template
2. Ensure script sources `$HOME/bin/window_utils.sh`
3. Use pgrep to check if already running
4. Use i3-scratchpad-show-or-create for launch
5. Set executable: `chmod +x scripts/toggle_newapp.sh`

### Modifying Keybindings
1. Edit the config file keybinding section
2. Use format: `bindsym $Mod+key exec --no-startup-id command`
3. Test with: `i3 -C -c config`
4. Apply with: `i3-msg reload`

### Status Bar Customization
The configuration uses i3status-rs instead of i3blocks. To modify:
1. Locate i3status-rs config (likely in ~/.config/i3status-rust/)
2. Modify blocks as needed
3. Restart: `killall i3status-rs && i3status-rs &`

## Troubleshooting

### Configuration Errors
```bash
# Validate config syntax
i3 -C -c /home/odd/dotfiles/config/i3/config

# Check i3 logs
journalctl --user -u i3 -n 50
```

### Scratchpad Issues
```bash
# List all scratchpad windows
i3-msg -t get_tree | jq '.nodes[].nodes[].nodes[] | select(.name=="__i3_scratch")'

# Reset scratchpad
i3-msg "scratchpad show" # Show all
i3-msg "kill" # Kill unwanted windows
```

### Missing Dependencies
If scripts fail, verify required tools are installed:
```bash
# Arch Linux
sudo pacman -S i3-wm rofi pamixer playerctl xorg-xbacklight dunst
yay -S i3-scratchpad-show-or-create-git
```

## Notes

- The configuration expects `window_utils.sh` to be available at `$HOME/bin/`
- Toggle scripts depend on i3-scratchpad-show-or-create utility
- Status bar uses i3status-rs, not the configured i3blocks.conf
- Some workspace assignments are commented out in config (lines 424-428)