# Third-Party Tools Used in Dotfiles Configuration

This document lists all non-default GNU/Linux tools used in the dotfiles configuration, categorized by their purpose and marked as essential or optional.

## Package Managers & System Tools

### Essential
- **yay** - AUR helper for Arch Linux
  - *Description*: Yet Another Yaourt - AUR helper with pacman syntax
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `sudo pacman -S yay`

- **paru** - Alternative AUR helper
  - *Description*: Feature-packed AUR helper
  - *Referenced in*: `rc.d/paru.zsh`
  - *Installation*: `yay -S paru`

### Optional
- **topgrade** - Universal upgrade tool
  - *Description*: Upgrade all the things (system packages, language packages, etc.)
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `yay -S topgrade`

## Shell Enhancement Tools

### Essential
- **zsh** - Z shell
  - *Description*: Extended Bourne shell with improvements
  - *Referenced in*: `.zshrc`, multiple config files
  - *Installation*: `sudo pacman -S zsh`

- **starship** - Cross-shell prompt
  - *Description*: Minimal, blazing-fast, and infinitely customizable prompt
  - *Referenced in*: `optimal_packages.md`
  - *Installation*: `sudo pacman -S starship`

- **atuin** - Shell history replacement
  - *Description*: Magical shell history with sync capabilities
  - *Referenced in*: `rc.d/atuin.zsh`, `optimal_packages.md`
  - *Installation*: `sudo pacman -S atuin`

- **zoxide** - Smart cd command
  - *Description*: A smarter cd command inspired by z and autojump
  - *Referenced in*: `rc.d/zoxide.zsh`, `optimal_packages.md`
  - *Installation*: `sudo pacman -S zoxide`

- **fzf** - Fuzzy finder
  - *Description*: Command-line fuzzy finder
  - *Referenced in*: `alias.d/aliases.zsh`, `optimal_packages.md`
  - *Installation*: `sudo pacman -S fzf`

### Optional
- **antidote** - Zsh plugin manager
  - *Description*: A zsh plugin manager made from the ground up thinking about performance
  - *Referenced in*: `zshrc.d/00-plugins.zsh`
  - *Installation*: `yay -S antidote`

- **redo** - Command history tool
  - *Description*: an interactive way combine multiple commands from your shell history in a single command
  - *Referenced in*: `rc.d/redo.zsh`
  - *Installation*: `go install github.com/barthr/redo@latest`

## File Management & Navigation

### Essential
- **exa** - Modern ls replacement
  - *Description*: A modern replacement for ls with colors and git integration
  - *Referenced in*: `alias.d/aliases.zsh`, `alias.d/directories.zsh`, `optimal_packages.md`
  - *Installation*: `sudo pacman -S exa`

- **bat** - Cat clone with syntax highlighting
  - *Description*: A cat clone with wings (syntax highlighting and git integration)
  - *Referenced in*: `rc.d/bat.zsh`, `optimal_packages.md`
  - *Installation*: `sudo pacman -S bat`

- **yazi** - Terminal file manager
  - *Description*: Blazing fast terminal file manager written in Rust
  - *Referenced in*: `rc.d/yazi.zsh`
  - *Installation*: `sudo pacman -S yazi`

### Optional
- **nemo** - File manager
  - *Description*: Cinnamon file manager
  - *Referenced in*: `.zshrc`, `optimal_packages.md`
  - *Installation*: `sudo pacman -S nemo`

- **thunar** - Lightweight file manager
  - *Description*: Modern file manager for Xfce
  - *Referenced in*: `.zshrc`
  - *Installation*: `sudo pacman -S thunar`

- **xcp** - Extended cp
  - *Description*: An extended cp command with progress bar
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `yay -S xcp`

## Text Editors & Viewers

### Essential
- **nvim** - Neovim
  - *Description*: Vim-fork focused on extensibility and usability
  - *Referenced in*: `.zshrc`
  - *Installation*: `sudo pacman -S neovim`

### Optional
- **helix** - Modern text editor
  - *Description*: A post-modern modal text editor
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `sudo pacman -S helix`

- **code** - Visual Studio Code
  - *Description*: Microsoft's code editor
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `yay -S visual-studio-code-bin`

- **doom emacs** - Emacs framework
  - *Description*: An Emacs framework for the stubborn martian hacker
  - *Referenced in*: `alias.d/aliases.zsh`, `.zshrc`
  - *Installation*: `yay -S doom-emacs-git`

- **zathura** - Document viewer
  - *Description*: Highly customizable document viewer
  - *Referenced in*: `.zshrc`, `alias.d/aliases.zsh`, `optimal_packages.md`
  - *Installation*: `sudo pacman -S zathura zathura-pdf-mupdf`
  - *Note*: Ensure to install the appropriate processor package for your system (e.g., `zathura-pdf-mupdf` for MuPDF support, `zathura-pdf-poppler` for Poppler support, etc.)

## Search & Text Processing

### Essential
- **ripgrep** - Fast grep alternative
  - *Description*: Line-oriented search tool that recursively searches directories
  - *Referenced in*: `rc.d/ripgrep.zsh`
  - *Installation*: `sudo pacman -S ripgrep`

- **fd** - Find alternative
  - *Description*: Simple, fast and user-friendly alternative to find
  - *Referenced in*: `rc.d/sk.zsh`
  - *Installation*: `sudo pacman -S fd`

### Optional
- **tldr** - Simplified man pages
  - *Description*: Collaborative cheatsheets for console commands
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `sudo pacman -S tldr`

- **skim** - Fuzzy finder alternative to fzf
  - *Description*: Fuzzy finder in Rust
  - *Referenced in*: `rc.d/sk.zsh`
  - *Installation*: `yay -S skim`

## Development Tools

### Essential
- **git** - Version control system
  - *Description*: Distributed version control system
  - *Referenced in*: Multiple files
  - *Installation*: `sudo pacman -S git`

- **gh** - GitHub CLI
  - *Description*: GitHub's official command line tool
  - *Referenced in*: `rc.d/gh_cli.zsh`
  - *Installation*: `sudo pacman -S github-cli`

### Optional
- **hub** - Git wrapper for GitHub
  - *Description*: Command-line wrapper for git that makes working with GitHub easier
  - *Referenced in*: `alias.d/git.zsh`
  - *Installation*: `yay -S hub`

- **git-delta** - Git diff viewer
  - *Description*: A syntax-highlighting pager for git and diff output
  - *Referenced in*: `optimal_packages.md`
  - *Installation*: `sudo pacman -S git-delta`

- **docker** - Containerization platform
  - *Description*: Platform for developing, shipping, and running applications in containers
  - *Referenced in*: `alias.d/aliases.zsh`, `alias.d/docker.zsh`
  - *Installation*: `sudo pacman -S docker docker-compose`

- **lazydocker** - Docker TUI
  - *Description*: Simple terminal UI for docker and docker-compose
  - *Referenced in*: `alias.d/docker.zsh`
  - *Installation*: `yay -S lazydocker`

- **pnpm** - Fast package manager
  - *Description*: Fast, disk space efficient package manager
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `sudo pacman -S pnpm`

## Language-Specific Tools

### Optional
- **ghc** - Haskell compiler
  - *Description*: The Glasgow Haskell Compiler
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `sudo pacman -S ghc`

- **dotnet** - .NET SDK
  - *Description*: Microsoft .NET development platform
  - *Referenced in*: `rc.d/dotnet.zsh`
  - *Installation*: `sudo pacman -S dotnet-sdk`

- **yarn** - JavaScript package manager
  - *Description*: Fast, reliable, and secure dependency management
  - *Referenced in*: `.zshrc`
  - *Installation*: `sudo pacman -S yarn`

## System Information & Monitoring

### Optional
- **htop** - Process viewer
  - *Description*: Interactive process viewer
  - *Referenced in*: Common system tool
  - *Installation*: `sudo pacman -S htop`

- **fastfetch** - System information tool
  - *Description*: Fast system information tool written in C
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `sudo pacman -S fastfetch`

## Multimedia & Graphics

### Essential
- **mpv** - Media player
  - *Description*: Free, open source, and cross-platform media player
  - *Referenced in*: `.zshrc`
  - *Installation*: `sudo pacman -S mpv`

### Optional
- **nsxiv** - Image viewer
  - *Description*: Neo Simple X Image Viewer
  - *Referenced in*: `alias.d/aliases.zsh`, `optimal_packages.md`
  - *Installation*: `sudo pacman -S nsxiv`

- **feh** - Image viewer
  - *Description*: Fast and light image viewer
  - *Referenced in*: `.zshrc`
  - *Installation*: `sudo pacman -S feh`

## Terminal & Terminal Tools

### Essential
- **kitty** - GPU-accelerated terminal
  - *Description*: Cross-platform, fast, feature-rich, GPU-accelerated terminal emulator
  - *Referenced in*: `.zshrc`, `alias.d/aliases.zsh`
  - *Installation*: `sudo pacman -S kitty`

### Optional
- **xterm** - Terminal emulator
  - *Description*: Standard terminal emulator for X Window System
  - *Referenced in*: `.zshrc`
  - *Installation*: `sudo pacman -S xterm`

## Networking Tools

### Optional
- **nmap** - Network scanner
  - *Description*: Network discovery and security auditing tool
  - *Referenced in*: `alias.d/aliases.zsh`, `alias.d/nmap.zsh`
  - *Installation*: `sudo pacman -S nmap`

- **curlie** - Curl frontend
  - *Description*: Frontend to curl that adds the ease of use of httpie
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `yay -S curlie`

- **warp-cli** - Cloudflare Warp CLI
  - *Description*: Cloudflare Warp VPN client
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `yay -S cloudflare-warp-bin`

- **wrangler2** - Cloudflare Workers CLI
  - *Description*: Command-line tool for working with Cloudflare Workers
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `yay -S wrangler-bin`

## Utilities & Miscellaneous

### Essential
- **xdg-utils** - Desktop integration utilities
  - *Description*: Command line tools that assist applications with desktop integration
  - *Referenced in*: `.zshrc`, `alias.d/aliases.zsh`
  - *Installation*: `sudo pacman -S xdg-utils`

### Optional
- **eva** - Calculator
  - *Description*: Simple calculator REPL, similar to bc
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `yay -S eva`

- **hyx** - Hex viewer
  - *Description*: Minimalistic but powerful Linux hex editor
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `yay -S hyx`

- **xsel** - X selection tool
  - *Description*: Command-line program for getting and setting X selection
  - *Referenced in*: `alias.d/aliases.zsh`, `optimal_packages.md`
  - *Installation*: `sudo pacman -S xsel`

- **xclip** - X clipboard tool
  - *Description*: Command line interface to X selections
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `sudo pacman -S xclip`

- **libby** - Library Genesis CLI
  - *Description*: Simple CLI tool to quickly download books from Library Genesis
  - *Referenced in*: `rc.d/libby.zsh`
  - *Installation*: `yay -S libby-git`

- **input-remapper** - Input device remapping
  - *Description*: Tool to remap input devices
  - *Referenced in*: `alias.d/aliases.zsh`
  - *Installation*: `yay -S input-remapper-git`

- **distrobox** - Container management
  - *Description*: Use any Linux distribution inside your terminal
  - *Referenced in*: `alias.d/distrbox.zsh`
  - *Installation*: `sudo pacman -S distrobox`

## Code Quality & Formatting Tools

### Optional
- **prettier** - Code formatter
  - *Description*: Opinionated code formatter
  - *Referenced in*: `optimal_packages.md`
  - *Installation*: `sudo pacman -S prettier`

- **shfmt** - Shell script formatter
  - *Description*: Shell parser, formatter, and interpreter
  - *Referenced in*: `optimal_packages.md`
  - *Installation*: `sudo pacman -S shfmt`

- **hadolint** - Dockerfile linter
  - *Description*: Haskell Dockerfile Linter
  - *Referenced in*: `optimal_packages.md`
  - *Installation*: `yay -S hadolint-bin`

- **ruff** - Python linter
  - *Description*: Extremely fast Python linter
  - *Referenced in*: `optimal_packages.md`
  - *Installation*: `sudo pacman -S ruff`

- **entr** - File watcher
  - *Description*: Run arbitrary commands when files change
  - *Referenced in*: `optimal_packages.md`
  - *Installation*: `sudo pacman -S entr`

## Browser & Web Tools

### Essential
- **firefox** - Web browser
  - *Description*: Free and open-source web browser
  - *Referenced in*: `.zshrc`, `optimal_packages.md`
  - *Installation*: `sudo pacman -S firefox`

### Optional
- **ungoogled-chromium** - Privacy-focused Chromium
  - *Description*: Chromium without Google integration
  - *Referenced in*: `rc.d/chromium.zsh`
  - *Installation*: `yay -S ungoogled-chromium`

- **nbrowser** - Custom browser
  - *Description*: Custom browser (specific to user setup)
  - *Referenced in*: `.zshrc`
  - *Installation*: Custom/user-specific

## Window Manager & Desktop

### Optional
- **i3** - Tiling window manager
  - *Description*: Improved tiling window manager
  - *Referenced in*: `.zshrc`, `alias.d/aliases.zsh`
  - *Installation*: `sudo pacman -S i3-wm`

## Archive Tools

### Optional
- **7z** - Archive utility
  - *Description*: File archiver with high compression ratio
  - *Referenced in*: `func.d/archive.zsh`
  - *Installation*: `sudo pacman -S p7zip`

- **rar** - RAR archiver
  - *Description*: Archive manager for RAR files
  - *Referenced in*: `func.d/archive.zsh`
  - *Installation*: `yay -S rar`

- **zstd** - Compression algorithm
  - *Description*: Fast real-time compression algorithm
  - *Referenced in*: `func.d/archive.zsh`
  - *Installation*: `sudo pacman -S zstd`

## Repository Management

### Optional
- **myrepos** - Multiple repository management
  - *Description*: Tool to manage multiple version control repositories
  - *Referenced in*: `alias.d/git.zsh`
  - *Installation*: `sudo pacman -S myrepos`

## Installation Summary

To install all essential tools:
```bash
sudo pacman -S yay zsh starship atuin zoxide fzf exa bat yazi nvim ripgrep fd git github-cli fastfetch mpv kitty xdg-utils firefox
```

To install all optional tools (using yay for AUR packages):
```bash
yay -S paru topgrade antidote redo helix visual-studio-code-bin emacs zathura zathura-pdf-mupdf tldr skim hub git-delta docker docker-compose lazydocker pnpm ghc dotnet-sdk yarn htop nsxiv sxiv feh xterm nmap curlie cloudflare-warp-bin wrangler-bin eva hyx xsel xclip libby-git input-remapper-git distrobox prettier shfmt hadolint-bin ruff entr ungoogled-chromium i3-wm p7zip rar zstd myrepos
```

Note: Some packages may have different names or may not be available in the official repositories. Always check package availability and names before installation.

## Additional Notes

### Zsh Plugins (via antidote)
The following zsh plugins are managed through antidote and don't require separate installation:
- **fzf-tab** - Replace zsh's default completion selection menu with fzf
- **zsh-autosuggestions** - Fish-like autosuggestions for zsh
- **fast-syntax-highlighting** - Feature-rich syntax highlighting for zsh
- **zsh-history-substring-search** - Fish-like history search for zsh
- **zsh-autopair** - Auto-close and delete matching delimiters
- **forgit** - Utility tool powered by fzf for using git interactively
- **cd-gitroot** - Change directory to git repository root
- **fuzzy-sys** - Utility for using systemctl interactively via fzf

### Package Alternatives
Some tools have alternatives that can be used interchangeably:
- **exa** vs **eza** (eza is a maintained fork of exa)
- **sxiv** vs **nsxiv** (nsxiv is a maintained fork of sxiv)
- **bat** vs **batcat** (different package names on some distributions)
- **fd** vs **fd-find** (different package names on some distributions)

### Custom Functions
The dotfiles include custom functions that don't require additional packages:
- **archive()** - Universal archive creation function
- **yy()** - Yazi wrapper that changes directory on exit

### Environment Variables
Many tools are configured through environment variables set in the dotfiles:
- **BAT_THEME** - Set to "Nord" for bat
- **PAGER** - Set to bat when available
- **EDITOR** - Set to nvim when available
- **BROWSER** - Set to firefox or custom nbrowser
- **TERMINAL** - Set to kitty when available
