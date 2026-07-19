#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(aerospace bin claude codex ghostty git karabiner nvim starship tmux zsh)

if ! command -v stow >/dev/null 2>&1; then
  echo "GNU Stow is required. Install it, then rerun this script." >&2
  exit 1
fi

hascmd() {
  command -v "$1" >/dev/null 2>&1
}

setup_shared_skills() {
  local target_dir="$1"
  local source_dir="$DOTFILES_DIR/agents/skills"
  local skill_dir skill_name target

  [ -d "$source_dir" ] || return

  mkdir -p "$target_dir"
  for skill_dir in "$source_dir"/*; do
    [ -d "$skill_dir" ] || continue

    skill_name="$(basename "$skill_dir")"
    target="$target_dir/$skill_name"

    if [ -L "$target" ]; then
      if [ "$(readlink "$target")" = "$skill_dir" ]; then
        continue
      fi

      rm "$target"
    elif [ -e "$target" ]; then
      continue
    fi

    ln -s "$skill_dir" "$target"
  done
}

remove_shared_skills() {
  local target_dir="$1"
  local source_dir="$DOTFILES_DIR/agents/skills"
  local skill_dir skill_name target

  [ -d "$source_dir" ] || return

  for skill_dir in "$source_dir"/*; do
    [ -d "$skill_dir" ] || continue

    skill_name="$(basename "$skill_dir")"
    target="$target_dir/$skill_name"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$skill_dir" ]; then
      rm "$target"
    fi
  done
}

install_tpm() {
  local tpm_dir="$HOME/.tmux/plugins/tpm"

  if [ -d "$tpm_dir" ]; then
    return 0
  fi

  echo "Installing TPM"
  mkdir -p "$(dirname "$tpm_dir")"
  git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
}

install_starship() {
  if hascmd starship || [ -x "$HOME/.local/bin/starship" ]; then
    return 0
  fi

  echo "Installing Starship"
  curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"
}

install_tuicr() {
  if hascmd tuicr; then
    return 0
  fi

  if hascmd brew; then
    echo "Installing tuicr with Homebrew"
    brew install agavra/tap/tuicr
  elif hascmd cargo; then
    echo "Installing tuicr with Cargo"
    cargo install tuicr
  else
    echo "Skipping tuicr installation (Homebrew or Cargo required)"
  fi
}

stow_package() {
  local package="$1"
  local operation="${2:-}"
  local -a args=(--no-folding --dir "$DOTFILES_DIR" --target "$HOME")

  if [ "${DOTFILES_SKIP_STOW_CONFIGS:-0}" = "1" ]; then
    case "$package" in
      claude) args+=(--ignore='^\.claude/settings\.json$') ;;
      codex) args+=(--ignore='^\.codex/(AGENTS\.md|config\.toml|hooks\.json)$') ;;
      git) args+=(--ignore='^\.gitconfig\.personal$') ;;
    esac
  fi

  if [ "$operation" = "--delete" ]; then
    args+=(--delete)
  fi

  stow "${args[@]}" "$package"
}

case "${1:-}" in
  --undo)
    for package in "${PACKAGES[@]}"; do
      stow_package "$package" --delete
    done
    if [ "${DOTFILES_SKIP_SKILLS:-0}" != "1" ]; then
      remove_shared_skills "$HOME/.agents/skills"
      remove_shared_skills "$HOME/.claude/skills"
    fi
    exit 0
    ;;
  "")
    ;;
  *)
    echo "Usage: $0 [--undo]" >&2
    exit 1
    ;;
esac

for package in "${PACKAGES[@]}"; do
  stow_package "$package"
done

if [ "${DOTFILES_SKIP_SKILLS:-0}" != "1" ]; then
  setup_shared_skills "$HOME/.agents/skills"
  setup_shared_skills "$HOME/.claude/skills"
fi

install_tpm
install_starship
install_tuicr
