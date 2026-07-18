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

  if [ -e "$target" ] || [ -L "$target" ]; then
    return
  fi

  mkdir -p "$(dirname "$target")"
  cp "$source" "$target"
}

migrate_legacy_codex_hooks_link() {
  local target="$HOME/.codex/hooks.json"
  local legacy_dir legacy_source

  legacy_dir="$(cd "$DOTFILES_DIR/codex/.codex" && pwd -P)"
  legacy_source="$legacy_dir/hooks.json"

  [ -L "$target" ] || return 0

  local link_target link_dir resolved_dir
  link_target="$(readlink "$target")"
  link_dir="$(dirname "$link_target")"

  if [[ "$link_target" = /* ]]; then
    resolved_dir="$(cd "$link_dir" 2>/dev/null && pwd -P)" || return 0
  else
    resolved_dir="$(cd "$(dirname "$target")/$link_dir" 2>/dev/null && pwd -P)" || return 0
  fi

  if [ "$resolved_dir/$(basename "$link_target")" = "$legacy_source" ]; then
    unlink "$target"
  fi
}

# These files accumulate runtime state, so keep a private working copy rather
# than a symlink back to this repository.
install_if_missing "$DOTFILES_DIR/templates/claude-settings.json" "$HOME/.claude/settings.json"
install_if_missing "$DOTFILES_DIR/templates/codex-config.toml" "$HOME/.codex/config.toml"
migrate_legacy_codex_hooks_link
install_if_missing "$DOTFILES_DIR/templates/codex-hooks.json" "$HOME/.codex/hooks.json"
