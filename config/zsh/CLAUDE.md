# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modular Zsh configuration within a larger dotfiles repository, organized with the XDG Base Directory specification. The configuration is split across multiple directories for better maintainability and performance optimization.

## Architecture

### Load Order

1. `$HOME/.zshenv` → Sets XDG directories and sources `config/zsh/env.d/env`
2. `config/zsh/env.d/env` → Shared POSIX-compliant environment variable defaults (with idempotency guard, no conditional logic)
3. `config/zsh/.zshrc` → Main configuration that loads directories in this order:
   - `zshrc.d/*.zsh` - Core Zsh configuration (plugins, completion, functions, history, prompt)
   - `func.d/*.zsh` - Custom shell functions
   - `rc.d/*.zsh` - Tool-specific configurations
   - `alias.d/*.zsh` - Shell aliases

### Performance Optimizations

- **Idempotency Guards**: Environment files use PID-based guards to prevent duplicate sourcing
- **Plugin Caching**: Antidote plugins are cached in `$ANTIDOTE_HOME/plugins.zsh`
- **Command Existence Checks**: All tool configs check for command availability before loading
- **Profiling**: Use `$ZDOTDIR/profile-startup.sh` for comprehensive startup time analysis

### Key Directories

- `alias.d/` - Aliases organized by tool/category
- `completion.d/` - Custom completions and completion cache
- `env.d/` - Environment variables (loaded early)
- `func.d/` - Custom shell functions
- `rc.d/` - Tool-specific configurations and category-based selectors
  - Category files: `browser.zsh`, `document_viewer.zsh`, `file_manager.zsh`, `image_viewer.zsh`, `diff_tool.zsh`
  - Tool files: `nvim.zsh`, `kitty.zsh`, `firefox.zsh`, etc.
- `zshrc.d/` - Core Zsh setup files

## Installation & Setup

1. Clone the dotfiles repository:

   ```bash
   git clone <repo-url> ~/dotfiles
   ```

2. Create symlink for Zsh configuration:

   ```bash
   ln -sf ~/dotfiles/config/zsh/.zshenv ~/.zshenv
   ```

3. Install essential dependencies (Arch Linux):

   ```bash
   # Core tools
   sudo pacman -S zsh starship fzf ripgrep fd bat eza atuin zoxide
   yay -S antidote-git
   
   # Additional recommended tools (from optimal_packages.md)
   sudo pacman -S bat-extras git-delta entr prettier shfmt sxiv zathura nemo firefox xsel
   
   # Linters and formatters
   sudo pacman -S hadolint ruff
   ```

## Development Commands

### Performance Profiling

```bash
# Run comprehensive startup profiling
$ZDOTDIR/profile-startup.sh

# Profile with zprof (detailed function timing)
ZSH_PROFILE=1 zsh -i -c exit

# Quick timing (average of 10 runs)
for i in {1..10}; do time zsh -i -c exit; done

# Test without plugins
mv $ANTIDOTE_HOME/plugins.zsh{,.bak}
time zsh -i -c exit
mv $ANTIDOTE_HOME/plugins.zsh{.bak,}
```

### Testing Changes

```bash
# Reload Zsh configuration
source ~/.zshenv && source $ZDOTDIR/.zshrc

# Test specific configuration file
source $ZDOTDIR/rc.d/new-tool.zsh

# Debug load order issues
DEBUG=1 zsh -i -c exit

# Test without cached plugins
mv $ANTIDOTE_HOME/plugins.zsh{,.bak} && zsh
mv $ANTIDOTE_HOME/plugins.zsh{.bak,}
```

### Adding New Configurations

- Aliases: Create file in `alias.d/` (e.g., `alias.d/mytool.zsh`)
- Functions: Add to `func.d/` or create new file
- Tool configs: Add to `rc.d/` (e.g., `rc.d/mytool.zsh`)
- Environment vars: Add to existing `env.d/.zshenv` or `.zshrc`

## Plugin Management

This configuration uses Antidote for plugin management. Plugins are defined in `zshrc.d/00-plugins.zsh`.

### Adding Plugins

1. Edit `zshrc.d/00-plugins.zsh`
2. Add plugin in the antidote bundle section
3. Remove the cached plugin file to trigger rebuild:

   ```bash
   rm $ANTIDOTE_HOME/plugins.zsh
   ```

## Key Patterns

### Command Existence Check

Use the native zsh syntax for checking command existence:

```zsh
if (( $+commands[mytool] )); then
    alias mt='mytool --color=auto'
fi
```


### Idempotency Guard Pattern

Used in environment files to prevent duplicate sourcing:

```zsh
_CURRENT_SHELL_PID=$$
if [ -n "$_ENV_SOURCED_PID" ] && [ "$_ENV_SOURCED_PID" = "$_CURRENT_SHELL_PID" ]; then
  return
fi
export _ENV_SOURCED_PID=$_CURRENT_SHELL_PID
```

### Tool Configuration

Tool-specific configs in `rc.d/` follow this pattern:

```zsh
# Tool: ToolName
# Desc: Brief description

# Check if tool exists
if ! (( $+commands[toolname] )); then
    return
fi

# Configuration
export TOOL_VAR="value"
alias tool='toolname --options'
```

### Alias Organization

Aliases are grouped by tool/purpose with consistent formatting:

```zsh
# Tool/Category name
alias short='long-command --with-options'
alias another='command2'
```

### Environment Variable Default+Override Pattern

Environment variables use a two-stage configuration pattern:

1. **Universal defaults in `env.d/env`** (POSIX-compliant):
   ```sh
   export EDITOR="vi"
   export BROWSER="firefox"
   export PAGER="less"
   ```

2. **Tool-specific overrides in `rc.d/`** files:
   - **Category-based files** for selecting between alternatives:
     ```zsh
     # rc.d/browser.zsh - Selects from multiple browsers
     if (( $+commands[nbrowser] )); then
         export BROWSER="nbrowser"
     elif (( $+commands[zen-browser] )); then
         export BROWSER="zen-browser"
     # ... more options
     fi
     ```
   
   - **Tool-specific files** for individual tool settings:
     ```zsh
     # rc.d/nvim.zsh - Neovim-specific settings
     if ! (( $+commands[nvim] )); then
         return
     fi
     export EDITOR="nvim"
     export VISUAL="$EDITOR"
     ```

This pattern provides:
- Universal fallbacks that work in all shells
- Progressive enhancement when better tools are available
- Clear separation between defaults and overrides
- Easy maintenance and tool discovery

## Important Files

- `3rd_party_tools.md` - Comprehensive list of all external tools used
- `optimal_packages.md` - Essential packages for best experience
- `$XDG_CACHE_HOME/zsh/zcompdump` - Zsh completion cache (auto-generated)

## Common Tasks

### Find where a command/alias is defined

```bash
grep -r "alias name" $ZDOTDIR/alias.d/
grep -r "function name" $ZDOTDIR/func.d/
```

### Check load order issues

```bash
# Enable debug mode (already set in .zshrc)
DEBUG=1
source ~/.zshenv && source $ZDOTDIR/.zshrc
```

### Update completion cache

```bash
rm $XDG_CACHE_HOME/zsh/zcompdump
compinit -d $XDG_CACHE_HOME/zsh/zcompdump
```

### Verify configuration syntax

```bash
# Check for syntax errors in zsh files
zsh -n $ZDOTDIR/**/*.zsh
```

## Environment Variables

Key environment variables set by this configuration:

- `ZDOTDIR` - Zsh configuration directory
- `ZSH_CONF_DIR` - Same as ZDOTDIR
- `ZSH_CACHE_DIR` - Cache directory for Zsh
- `ANTIDOTE_HOME` - Plugin manager cache directory
- `DOTFILES` - Path to dotfiles repository

## Common Development Tasks

### Adding a New Tool Configuration

1. Create config file: `$ZDOTDIR/rc.d/newtool.zsh`
2. Follow the standard pattern with command existence check
3. Consider impact on startup time using profiling tools

### Debugging Slow Startup

1. Run `$ZDOTDIR/profile-startup.sh` to identify bottlenecks
2. Check command existence checks in tool configs
3. Verify plugin cache exists: `ls -la $ANTIDOTE_HOME/plugins.zsh`
4. Test startup without specific directories to isolate issues

### Working with Environment Variables

- Universal defaults: Edit `env.d/env` (POSIX-compliant, no conditionals)
- Tool-specific overrides: Create or edit appropriate `rc.d/` file
- Category selections: Use category files in `rc.d/` (browser.zsh, etc.)
- Shell-specific variables: Add to `.zshrc` or appropriate `rc.d/` file
- Remember idempotency guards for files sourced multiple times

## Key Bindings

The configuration includes custom vi-like navigation bindings defined in `.zshrc`:
- `Ctrl+h` - Move backward by word
- `Ctrl+j` - Down in command history (with search)
- `Ctrl+k` - Up in command history (with search)
- `Ctrl+l` - Move forward by word
- `Ctrl+u` / `Ctrl+w` - Delete word backward
- `Arrow Up/Down` - Navigate history with search

## Claude Code Integration

The configuration includes dedicated Claude Code settings in `rc.d/claude-code.zsh`:
- Sets environment variables for model selection (`ANTHROPIC_MODEL`)
- Configures telemetry and privacy settings (disabled by default)
- Sets timeout and output limits for bash operations
- Configures first-time Claude setup with preferred settings

## Recent Structure Changes

- Pacman package management functions have been moved from `zshrc.d/02-pacman-functions.zsh` to `func.d/pacman-pkg-mngmt.zsh`
- Functions include: `aur_search`, `blackarch_search`, `pacnew`, and other package management utilities
- Lazy loading system has been removed - all tools now load directly with command existence checks

## Notes

- The configuration assumes Arch Linux with yay/paru for package management
- Many aliases depend on specific tools being installed (see `3rd_party_tools.md`)
- Vi-like key bindings are configured for command line navigation (hjkl for history/word navigation)
- The prompt is managed by Starship (separate configuration)
- Debug mode can be enabled with `DEBUG=1` for troubleshooting
- Maximum function nesting is set to 1000 (`FUNCNEST=1000`)
- This Zsh configuration is part of a larger dotfiles repository managed with dotbot
