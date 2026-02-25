# # Completion
# #
# # do not autoselect the first completion entry
# unsetopt menu_complete

# # 20.2.1 Use of compinit
# # https://zsh.sourceforge.io/Doc/Release/Completion-System.html#Use-of-compinit

# autoload -Uz compinit

# # Add custom completion directory to fpath
# fpath=("${XDG_DATA_HOME:-$HOME/.local/share/zsh}/" $fpath)

# # set compinit dump file locaton
# compinit -d "${XDG_DATA_HOME:-$HOME/.local/share/zsh}/.zshcompdump"

# # Case-insensitive and hyphen insensitive path-completion
# CASE_SENSITIVE=false
# HYPHEN_INSENSITIVE=true

# if [[ "$CASE_SENSITIVE" = true ]]; then
#   zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
# else
#   if [[ "$HYPHEN_INSENSITIVE" = true ]]; then
#     zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
#   else
#     zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
#   fi
# fi
# unset CASE_SENSITIVE HYPHEN_INSENSITIVE

# # Complete . and .. special directories
# zstyle ':completion:*' special-dirs true

# # disable named-directories autocompletion
# zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# # Use caching so that commands like apt and dpkg complete are useable
# zstyle ':completion:*' use-cache yes
# zstyle ':completion:*' cache-path $ZSH_CACHE_DIR

# # Don't complete uninteresting users
# zstyle ':completion:*:*:*:users' ignored-patterns \
#         adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
#         clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
#         gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
#         ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
#         named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
#         operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
#         rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
#         usbmux uucp vcsa wwwrun xfs '_*'

# # ... unless we really want to.
# zstyle '*' single-ignored show

# On-demand rehash
# # https://wiki.archlinux.org/title/zsh#On-demand_rehash
# Typically, compinit will not automatically find new executables in the $PATH.
# For example, after you install a new package, the files in /usr/bin/
# would not be immediately or automatically included in the completion.
# however pacman can be configured with hooks to automatically request a rehash
# hook: /etc/pacman.d/hooks/zsh.hook
#
#zshcache_time="$(date +%s%N)"

#autoload -Uz add-zsh-hook

#rehash_precmd() {
#  if [[ -e /var/cache/zsh/pacman ]]; then
#    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
#    if ((zshcache_time < paccache_time)); then
#      rehash
#      zshcache_time="$paccache_time"
#    fi
#  fi
#}

# add-zsh-hook -Uz precmd rehash_precmd
