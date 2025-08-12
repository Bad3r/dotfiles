# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This directory contains rofi application launcher configurations for an EndeavourOS-based i3 window manager setup. Rofi is used as the primary menu system for application launching, window switching, system power management, and displaying keyboard shortcuts.

## Configuration Structure

### Main Configuration Files
- **config.rasi** - Primary rofi configuration with global settings
  - Font: MonoLisa Variable 11
  - Icon theme: Qogir-dark
  - Default theme: GitHub Dark Dimmed
  - Configured modes: window, drun, run, ssh, combi, json-menu, file-browser, calc
  - Terminal: kitty

### Menu-Specific Configurations
- **powermenu.rasi** - System power menu (logout/reboot/shutdown)
  - Positioned on the east side
  - 7-line vertical menu
  - No input bar (mainbox only shows listview)
  
- **rofikeyhint.rasi** - i3 keyboard shortcut display
  - 10-line display
  - Fullscreen disabled
  - Used to show keybinding hints

- **power-profiles.rasi** - Power profile selector
  - 4-line menu
  - Custom prompt: "Set Power Profile:"
  - East-positioned like powermenu

- **rofidmenu.rasi** - Additional dmenu configuration

### Theme System
Located in `themes/` directory:
- **github_dark_dimmed.rasi** - Active theme matching i3 color scheme
- Nord.rasi, arc_dark_colors.rasi, deep-purple.rasi - Alternative themes

Color variables follow rofi naming convention:
- `selected-normal-foreground/background`
- `normal-foreground/background`
- `urgent-foreground/background`
- `active-foreground/background`
- `alternate-*` variants for striping

## Integration with i3

### Launch Commands
Rofi is launched via `~/dotfiles/i3/rofi_run` script with these i3 keybindings:
```bash
$Mod+d    # Desktop launcher (drun mode)
$Mod+b    # Emoji picker (rofimoji)
$Mod+x    # System logout menu
```

### Script Integration
- **powermenu script** (`~/.config/i3/scripts/powermenu`)
  - Uses `~/.config/rofi/powermenu.rasi` theme
  - Handles system power state changes
  
- **keyhint script** (`~/.config/i3/scripts/keyhint-2`)
  - Uses `~/.config/rofi/rofikeyhint.rasi` theme
  - Displays i3 keybindings

- **power-profiles script** (`~/.config/i3/scripts/power-profiles`)
  - Uses `~/.config/rofi/power-profiles.rasi` theme
  - Manages system power profiles

## Common Commands

### Testing Configuration Changes
```bash
# Test rofi configuration syntax
rofi -config ~/.config/rofi/config.rasi -show drun

# Test specific menu configurations
rofi -theme ~/.config/rofi/powermenu.rasi -show dmenu
rofi -theme ~/.config/rofi/rofikeyhint.rasi -show dmenu

# Test theme changes
rofi -theme ~/.config/rofi/themes/github_dark_dimmed.rasi -show drun
```

### Rofi Launch Modes
```bash
# Application launcher
rofi_run -d
# or
rofi -modi drun -show drun

# Window switcher
rofi_run -w
# or
rofi -show window

# Calculator mode (requires libqalculate)
rofi -modi "calc:qalc +u8 -nocurrencies" -show calc

# File browser
rofi -show file-browser
```

## Customization Patterns

### Adding New Menus
1. Create new .rasi configuration file based on existing templates
2. Import base config: `@import "~/.config/rofi/config.rasi"`
3. Override specific properties (window size, position, listview lines)
4. Create launch script in `~/.config/i3/scripts/` if needed

### Theme Modifications
- All configurations import the base theme via `@theme` or `@import`
- Override specific color variables or widget properties after import
- Window positioning: use `location:` (north, south, east, west, center)
- Size control: `width:`, `lines:`, `columns:`

### RASI Syntax Notes
- Colors support rgba and hex formats
- Use `@variable` to reference defined variables
- Widget hierarchy: window → mainbox → (message, listview, mode-switcher, inputbar)
- `children:` property controls widget composition

## Dependencies

- **rofi** - Main application launcher
- **libqalculate** - For calculator mode
- **rofimoji** - Emoji picker integration
- **MonoLisa Variable** font - Display font
- **Qogir/Qogir-dark** - Icon theme

## File Validation

When modifying configurations:
1. RASI files must have valid CSS-like syntax
2. Color values must be valid hex or rgba
3. Widget properties must match rofi's expected types
4. Theme imports must reference existing files