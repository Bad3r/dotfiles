
# Completion
# 20.2.1 Use of compinit
# https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Use-of-compinit

autoload -Uz compinit
# set compinit dump file locaton 
# defualt:  ($ZDOTDIR or $HOME)/.zcompdump
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zshcompdump"

# Case-insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# On-demand rehash
# using a pacman hook
# https://wiki.archlinux.org/title/zsh#On-demand_rehash
zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd
