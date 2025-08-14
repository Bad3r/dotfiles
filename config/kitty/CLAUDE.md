# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Kitty terminal configuration directory within a larger dotfiles repository. The main repository manages system-wide configurations using Dotbot for symlinking.

## Architecture

### Configuration Structure
- **Main config**: `kitty.conf` - Primary Kitty configuration file with extensive customization options
- **Theme system**: Multiple theme files (`*.conf`) with `current-theme.conf` as the active theme
- **Theme switching**: Themes are included via `include current-theme.conf` directive in kitty.conf
- **Available themes**: GitHub Dark Dimmed (current), Dracula, Nord, MaterialDark

### Integration Points
- Part of dotfiles repository at `/home/vx/dotfiles`
- Managed by Dotbot installation script (`z-install-dots`)
- Integrates with ZSH configuration via `config/zsh/rc.d/kitty.zsh`

## Common Commands

### Theme Management
```bash
# Switch theme by editing kitty.conf line 8
# Change: include current-theme.conf
# To: include dracula.conf (or any other theme file)

# Reload configuration
ctrl+shift+f5  # Within Kitty terminal
```

### Debugging
```bash
# Show current configuration (mapped to F2)
# Press F2 within Kitty

# Show Kitty documentation (mapped to F1)  
# Press F1 within Kitty
```

### Installation
```bash
# From dotfiles root directory
./z-install-dots  # Installs all dotfiles including Kitty config
```

## Key Configuration Patterns

1. **vim-style folding**: Configuration uses vim folding markers (`{{{` and `}}}`) for organization
2. **Font configuration**: Set at line 30 with `font_size 13.2`
3. **Theme inclusion**: Line 8 includes the current theme file
4. **Extensive documentation**: Most options include detailed inline comments explaining their purpose