# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the Kitty directory within a larger dotfiles repository. `kitty.conf` is not tracked here: Home Manager in the `Bad3r/nixos` flake generates it from `modules/hm-apps/kitty.nix`. Edit that module and rebuild to change Kitty settings. What remains here are legacy theme files from before the migration.

## Architecture

### Configuration Structure
- **Main config**: `~/.config/kitty/kitty.conf` is a Home Manager store symlink. It is read-only and never committed (`.gitignore` lists it).
- **Colors**: Stylix supplies them. The generated config includes a base16 theme from the Nix store and does not include any file in this directory.
- **Legacy themes**: `current-theme.conf`, GitHub Dark Dimmed, Dracula, Nord, MaterialDark, Solarized Dark. The generated config does not use them.

### Integration Points
- Part of dotfiles repository at `/home/vx/dotfiles`
- Dotbot (`z-install-dots`) links `~/.config/kitty` to this directory, so Home Manager writes `kitty.conf` through that link

## Common Commands

```bash
# Reload configuration
ctrl+shift+f5  # Within Kitty terminal
```
