# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive Linux dotfiles repository containing configuration files for various applications and development tools. The repository uses dotbot for installation management and follows the XDG Base Directory specification.

## Common Commands

### Installation & Deployment
```bash
# Install/update dotfiles using dotbot
./z-install-dots

# Link specific configurations (Electron app configs)
./link_conf.sh

# Update all system packages and tools
topgrade

# Update git submodules
git submodule update --init --recursive
```

### Testing Changes

#### i3 Window Manager
```bash
# Reload i3 configuration
i3-msg reload

# Test i3 configuration for errors
i3 -C -c config/i3/config

# Test toggle scripts
~/.config/i3/scripts/toggle_logseq.sh
~/.config/i3/scripts/toggle_obsidian.sh
```

#### Zsh Configuration
```bash
# Reload Zsh configuration
source ~/.zshenv && source $ZDOTDIR/.zshrc

# Profile Zsh startup time
$ZDOTDIR/profile-startup.sh

# Test specific configuration file
source $ZDOTDIR/rc.d/new-tool.zsh

# Update Zsh completion cache
rm -f $XDG_CACHE_HOME/zsh/zcompdump && compinit
```

#### Neovim
```bash
# Update Neovim plugins
nvim -c "Lazy update" -c "qa"

# Check Neovim health
nvim -c "checkhealth" -c "qa"
```

### System Services
```bash
# Reload systemd user services
systemctl --user daemon-reload

# Restart dunst notification daemon
systemctl --user restart org.freedesktop.Notifications.service

# Check status of Claude automation service
systemctl --user status claude_reset.service

# View Claude timer schedule
systemctl --user list-timers claude_reset.timer
```

### Git Workflow
```bash
# Create multiple signed commits based on changes
git add <files>
git commit -S -m "type(scope): description"

# Recommended commit types:
# feat: new feature
# fix: bug fix
# chore: maintenance tasks
# refactor: code restructuring
# docs: documentation changes
```

### Kernel Parameter Management
```bash
# Edit kernel command line parameters
~/.local/bin/edit-kernel-params

# Verify current kernel parameters
~/.local/bin/verify-kernel-params

# After changes, regenerate boot entries
sudo kernel-install add-all
```

## Architecture

### Directory Structure
- **config/** - Application configurations following XDG specification
  - **i3/** - i3 window manager config and scripts
  - **zsh/** - Modular Zsh configuration with lazy loading
  - **nvim/** - Neovim configuration with lazy.nvim
  - **dunst/** - Notification daemon configuration
  - **kitty/** - Terminal emulator configuration
  - **rofi/** - Application launcher configuration
  - **systemd/user/** - User systemd services and timers
- **etc/** - System-wide configuration files
  - **kernel/cmdline.d/** - Modular kernel parameter configuration
  - **kernel/install.d/** - Kernel installation hooks
- **.local/bin/** - Custom user scripts and utilities
- **bin_bk/** - Backup of custom scripts
- **themes/** - Color schemes and theme files
- **misc/** - Miscellaneous utilities and scripts

### Key Configuration Patterns

#### Zsh Modular Loading
The Zsh configuration uses a sophisticated modular loading system:
1. **env.d/** - Environment variables (POSIX-compliant)
2. **zshrc.d/** - Core Zsh setup (loaded sequentially)
3. **func.d/** - Custom shell functions
4. **rc.d/** - Tool-specific configs (some lazy-loaded)
5. **alias.d/** - Organized aliases by tool/category

#### i3 Window Manager Scripts
Toggle scripts in `config/i3/scripts/` follow this pattern:
- Check if application is running
- Launch or kill based on current state
- Use wmctrl/xdotool for window management

#### Dotbot Configuration
The `z-install.conf.yml` defines symlinks and installation rules. When adding new configurations:
1. Add entry to `z-install.conf.yml`
2. Run `./z-install-dots` to create symlinks

#### Kernel Parameter Management
The repository includes a modular kernel command line configuration system:
- **`etc/kernel/cmdline.d/*.conf`** - Individual parameter files (e.g., 10-intel-graphics.conf, 20-performance.conf)
- **`etc/kernel/install.d/85-cmdline-d.install`** - Hook that combines modular configs into `/etc/kernel/cmdline`
- Parameters are organized by category (graphics, performance, storage, etc.)
- The system automatically combines and deduplicates parameters during kernel installation

### Performance Considerations
- Zsh uses lazy loading for heavy tools (zoxide, atuin, dotnet)
- Plugin caching via Antidote reduces startup time
- i3 scripts use minimal dependencies for fast execution

## Development Workflow

### Adding New Tool Configurations
1. **Zsh alias/function**: Create file in `config/zsh/alias.d/` or `func.d/`
2. **Tool config**: Add to `config/zsh/rc.d/toolname.zsh`
3. **i3 keybinding**: Edit `config/i3/config` and reload
4. **System service**: Add to `config/systemd/user/` or `etc/systemd/`

### Testing Patterns
```bash
# Test without modifying actual configs
cp config/i3/config config/i3/config.test
# Make changes to config.test
i3 -c config/i3/config.test

# Test Zsh changes in isolated session
zsh -f  # Start without configs
source path/to/test/config
```

### Common File Locations
- Shell aliases: `config/zsh/alias.d/`
- i3 keybindings: `config/i3/config` (search for `bindsym`)
- Application launchers: `config/rofi/`
- Terminal config: `config/kitty/kitty.conf`
- Editor config: `config/nvim/init.lua`

## Important Notes

### Git Submodules
The repository includes several submodules:
- **`.dotbot`** - Dotbot installation framework for managing symlinks
- **`.antidote`** - Fast Zsh plugin manager for performance optimization
- **`.i3sass`** - i3 window manager utilities and enhancements
- **`Mullvad-iOS-MacOS-DNS-Profiles`** - DNS configuration profiles

Update all submodules with: `git submodule update --init --recursive`

### Security Considerations
Before making the repository public:
- Review for hardcoded paths containing usernames (e.g., `/home/odd/`)
- Check for API keys in weather scripts (`config/i3/scripts/openweather*`)
- Consider removing or gitignoring user-specific configs like `qBittorrent.conf`
- Ensure no private IP addresses or sensitive ports are exposed

### Tool Dependencies
- Many configurations depend on specific tools being installed (see `config/zsh/3rd_party_tools.md`)
- Recommended essential packages: `bat bat-extras starship zoxide git-delta fzf eza entr prettier shfmt atuin sxiv zathura nemo firefox antidot xsel`
- i3 configuration uses `$Mod` (Super/Windows key) for most keybindings
- Electron app configs should not be symlinked entirely - use `link_conf.sh` pattern
- System-wide configs in `etc/` may require sudo to install

### Topgrade Configuration
The repository includes automated update configuration at `config/topgrade.d/topgrade.toml`:
- Disabled updaters: bun, pipx, uv, system, emacs, nix, self_update, yarn, pnpm
- Configured for Arch Linux package management
- Run with: `topgrade`

### Active Maintenance Items
From `TODO.md` - Areas that need attention:
- Complete the `z-install.conf.yml` dotbot configuration (currently incomplete)
- Fix AI-generated content in `config/zsh/3rd_party_tools.md`
- Consider moving zsh/nix configs to separate repositories as submodules
- Track additional system configurations like `/etc/udisks2/mount_options.conf`
- Replace deprecated tools (scot → maim for screenshots)

## Troubleshooting

### Zsh Slow Startup
```bash
# Profile to identify bottlenecks
ZSH_PROFILE=1 zsh -i -c exit

# Check if plugin cache exists
ls -la $ANTIDOTE_HOME/plugins.zsh

# Test without plugins
mv $ANTIDOTE_HOME/plugins.zsh{,.bak} && zsh
```

### i3 Configuration Issues
```bash
# Check configuration syntax
i3 -C -c config/i3/config

# View i3 logs
journalctl --user -u i3 -n 50
```

### Missing Commands
Most tools are listed in `config/zsh/3rd_party_tools.md`. Install with:
```bash
# Arch Linux
sudo pacman -S <package>
# or
yay -S <package>
```