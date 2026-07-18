[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.zsh_env ] && source ~/.zsh_env

# Optional employer or machine overlay.
[ -f ~/.config/dotfiles/local.zsh ] && source ~/.config/dotfiles/local.zsh

# Zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Starship must initialize last so optional overlays cannot replace the prompt.
command -v starship &>/dev/null && eval "$(starship init zsh)"
