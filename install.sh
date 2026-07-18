#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(aerospace bin claude codex ghostty git karabiner nvim starship tmux zsh)

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is required. Install it, then rerun this script." >&2
  exit 1
fi

for package in "${PACKAGES[@]}"; do
  stow --no-folding --dir "$DOTFILES_DIR" --target "$HOME" "$package"
done

install_if_missing() {
  local source="$1"
  local target="$2"

  if [ -e "$target" ]; then
    return
  fi

  mkdir -p "$(dirname "$target")"
  cp "$source" "$target"
}

# These files accumulate runtime state, so keep a private working copy rather
# than a symlink back to this repository.
install_if_missing "$DOTFILES_DIR/templates/claude-settings.json" "$HOME/.claude/settings.json"
install_if_missing "$DOTFILES_DIR/templates/codex-config.toml" "$HOME/.codex/config.toml"
