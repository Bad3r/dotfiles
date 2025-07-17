#---------------------------------------------------------------------------
# *                            Plugins Configuration
#---------------------------------------------------------------------------
# !NOTE: This file is sourced before other .zshrc.d files due to completion being configured via ez-compinit plugin

export ANTIDOTE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}/antidote
export ZSH_COMPDUMP="${ZSH_CONF_DIR:-$HOME/.config/zsh}/completion.d/.zshcompdump"
PLUGINS_CONF_FILE="${${(%):-%N}:A}" # this file
PLUGINS_DST_FILE="$ANTIDOTE_HOME/plugins.zsh"

# Enable ez-compinit caching to prevent regenerating dump file on every shell start
zstyle ':plugin:ez-compinit' 'use-cache' 'yes'


if [[ ! "$PLUGINS_DST_FILE" -nt "$PLUGINS_CONF_FILE" ]]; then
    [[ -e "$DOTFILES/.antidote/antidote.zsh" ]] && source "$DOTFILES/.antidote/antidote.zsh"
    mkdir -p "${PLUGINS_DST_FILE:h}"
    
    antidote bundle <<-plugins >| "$PLUGINS_DST_FILE"
    mattmc3/ez-compinit
    zsh-users/zsh-completions kind:fpath path:src
    mattmc3/zfunctions
    zsh-users/zsh-autosuggestions
    zdharma-continuum/fast-syntax-highlighting kind:defer
    zsh-users/zsh-history-substring-search
    # evanthegrayt/vagrant-box-wrapper
    NullSense/fuzzy-sys kind:defer
    # g-plane/pnpm-shell-completion
    hlissner/zsh-autopair kind:defer
    Aloxaf/fzf-tab kind:defer
    wfxr/forgit kind:defer
    mollifier/cd-gitroot kind:defer
    # sindresorhus/pure kind:fpath
plugins
fi

source "$PLUGINS_DST_FILE"

# Override ez-compinit's run-compinit to use 1-hour cache instead of 20 hours
function run-compinit {
  emulate -L zsh
  setopt local_options extended_glob

  # Use whatever ZSH_COMPDUMP is set to, or use an appropriate cache directory.
  local zcompdump
  if [[ -n "$ZSH_COMPDUMP" ]]; then
    zcompdump="$ZSH_COMPDUMP"
  else
    zcompdump=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump
  fi

  # Make sure zcompdump's directory exists and doesn't have a leading tilde.
  zcompdump="${~zcompdump}"
  [[ -d $zcompdump:h ]] || mkdir -p $zcompdump:h

  # `run-compinit -f` forces a cache reset.
  if [[ "$1" == (-f|--force) ]]; then
    shift
    [[ -r "$zcompdump" ]] && rm -rf -- "$zcompdump"
  fi

  # Initialize completions
  local -a compinit_flags=(-d "$zcompdump")
  autoload -Uz compinit
  if zstyle -t ':plugin:ez-compinit' 'use-cache'; then
    # 1 hour cache
    local zcompdump_cache=($zcompdump(Nmh-1))
    if (( $#zcompdump_cache )); then
      # -C (skip function check) implies -i (skip security check).
      compinit -C $compinit_flags
    else
      compinit -i $compinit_flags
      touch "$zcompdump"  # Ensure timestamp updates to reset the cache timeout.
    fi
  else
    compinit $compinit_flags
  fi

  # Compile zcompdump, if modified, in background to increase startup speed.
  {
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
      if command mkdir "${zcompdump}.zwc.lock" 2>/dev/null; then
        zcompile "$zcompdump"
        command rmdir  "${zcompdump}.zwc.lock" 2>/dev/null
      fi
    fi
  } &!
}
