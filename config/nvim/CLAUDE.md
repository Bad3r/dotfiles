# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview
This is a minimal Neovim configuration that uses lazy.nvim as the plugin manager. The entire configuration is contained in a single `init.lua` file. This is part of a larger dotfiles repository.

## Common Commands

### Plugin Management
```bash
# Update all plugins
nvim -c "Lazy update" -c "qa"

# Sync plugins (install/update/clean)
nvim -c "Lazy sync" -c "qa"

# Check plugin health
nvim -c "checkhealth" -c "qa"
```

In Neovim:
- `:Lazy` - Open plugin manager UI
- `:Lazy update` - Update all plugins
- `:Lazy sync` - Sync plugin state with config
- `:Lazy clean` - Remove unused plugins
- `:Lazy restore` - Restore plugins from `lazy-lock.json`

### Configuration Development
- **Reload configuration**: `:source $MYVIMRC` or restart Neovim
- **Check for errors**: `:checkhealth`
- **Plugin installation path**: `~/.local/share/nvim/lazy/`
- **Lock file**: `lazy-lock.json` tracks exact plugin versions

### Code Formatting
The repository includes `biome.json` for JavaScript/TypeScript formatting:
```bash
# Format files with biome (if installed)
biome format --write init.lua
```

## Architecture

### Core Configuration (`init.lua`)
1. **Options**: Lines 2-20 configure editor behavior (no swap files, system clipboard, relative numbers)
2. **Leader key**: Space (`vim.g.mapleader = " "`)
3. **Keymaps**: Lines 25-37 define core mappings
4. **Plugin bootstrap**: Lines 39-51 auto-install lazy.nvim
5. **Plugin definitions**: Lines 54-103 configure plugins

### Installed Plugins
- **github-nvim-theme**: GitHub Dark Dimmed colorscheme (primary theme)
- **Comment.nvim**: Smart commenting with `gcc` (line) and `gc` (visual)
- **which-key.nvim**: Shows key binding hints (300ms timeout)
- **nvim-web-devicons**: File type icons for UI
- **mini.icons**: Additional icon support

### Key Mappings
```
<Space>     - Leader key
<leader>pv  - Project explorer (netrw)
<leader>y   - Yank to system clipboard (visual mode)
<leader>Y   - Yank line to system clipboard
<leader>p   - Paste from system clipboard

<C-/>       - Toggle comment (normal and visual)
J           - Move line down (visual mode)
K           - Move line up (visual mode)
<C-d>       - Page down (centered)
<C-u>       - Page up (centered)
n/N         - Next/previous search (centered)
```

### Configuration Settings
- **Indentation**: 4 spaces (no tabs)
- **Line numbers**: Relative with absolute current line
- **No backups**: Swap and backup files disabled
- **Search**: Incremental search, no highlight persist
- **Scrolloff**: 8 lines padding when scrolling
- **Update time**: 50ms for responsive UI

## Integration with Dotfiles

This configuration is managed via dotbot in the parent repository:
- Symlinked from `~/dotfiles/config/nvim/` to `~/.config/nvim/`
- Deploy with: `cd ~/dotfiles && ./z-install-dots`
- Environment variables set in `~/dotfiles/config/zsh/rc.d/nvim.zsh`:
  - `EDITOR=nvim`
  - `VISUAL=nvim`