# ~/.config/zsh/env.d/interactive.zsh - Interactive/session-scoped environment
# Sourced by ~/.zshrc after the interactive-shell guard succeeds.

export WM="i3"

# Theme font defaults for terminal/UI sessions.
export THEME_FONT_FACE="MonoLisa Variable"
export THEME_FONT_SIZE=11

# fzf defaults - use PATH-resolved fd and keep absolute paths for robust selection.
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --absolute-path"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git --absolute-path"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Keep GPG_TTY tied to a real terminal session.
if [[ -n "${TTY-}" ]]; then
  export GPG_TTY="$TTY"
else
  unset GPG_TTY
fi
