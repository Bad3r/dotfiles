#---------------------------------------------------------------------------
# *                            Plugins Configuration
#---------------------------------------------------------------------------
# !NOTE: This file is sourced before other .zshrc.d files due to completion being configured via ez-compinit plugin

ANTIDOTE_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/antidote"
ANTIDOTE_BIN="${DOTFILES:-$HOME/dotfiles}/.antidote/antidote.zsh"

PLUGINS_CONF_FILE="${0:A}" # this file
PLUGINS_DST_FILE="$ANTIDOTE_HOME/plugins.zsh"

# Enable ez-compinit caching to prevent regenerating dump file on every shell start
zstyle ':plugin:ez-compinit' 'use-cache' 'yes'

typeset -ga ANTIDOTE_SOURCES=(
  "$ANTIDOTE_BIN"
  "$ANTIDOTE_HOME/antidote.zsh"
  "/usr/share/antidote/antidote.zsh"
  "/usr/share/zsh-antidote/antidote.zsh"
)

for antidote_source in $ANTIDOTE_SOURCES; do
  [[ -r "$antidote_source" ]] || continue
  source "$antidote_source"
  break
done

if [[ ! -s "$PLUGINS_DST_FILE" || "$PLUGINS_DST_FILE" -ot "$PLUGINS_CONF_FILE" ]]; then
  mkdir -p "${PLUGINS_DST_FILE:h}" 2>/dev/null

  if (( $+functions[antidote] || $+commands[antidote] )); then
    antidote bundle <<-'plugins' >|"$PLUGINS_DST_FILE"
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
      nix-community/nix-zsh-completions kind:defer
plugins
  else
    print -u2 "zsh: antidote unavailable; skipping plugin regeneration"
  fi
fi

[[ -s "$PLUGINS_DST_FILE" ]] && source "$PLUGINS_DST_FILE"
