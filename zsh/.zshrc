[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.zsh_env ] && source ~/.zsh_env

# Optional employer or machine overlay.
[ -f ~/.config/dotfiles/local.zsh ] && source ~/.config/dotfiles/local.zsh

# Zoxide (must be last in .zshrc)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi
