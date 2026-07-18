# dotfiles

Portable macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

Clone this repository to `~/dotfiles`, then run:

```sh
./install.sh
```

The installer only creates symlinks and stops on an existing conflicting file.
It never overwrites configuration. Claude and Codex settings are an exception:
their templates are copied only when the live settings file does not yet exist,
so runtime state cannot modify this repository. Machine- or employer-specific additions belong
in an optional overlay repository; the base configuration automatically loads
the zsh, tmux, and Git hooks that such an overlay provides.
Zoxide history is created locally and is never stored in this repository.

## Optional local files

- `~/.config/dotfiles/local.zsh` is sourced by zsh when present.
- `~/.config/tmux/local.conf` is sourced by tmux when present.
- `~/.gitconfig.personal` can hold a private Git identity.
- `~/.gitconfig.local` is loaded by Git when present.

## Git identity

The base Git config is symlinked into this checkout. Keep your account identity
in the private `~/.gitconfig.personal` file rather than using `git config
--global`, which would modify the checkout. Configure it once with:

```sh
git config --file ~/.gitconfig.personal user.name "Your Name"
git config --file ~/.gitconfig.personal user.email "you@example.com"
```

Employer overlays load after this file and can conditionally override the
identity for work repositories.

## Packages

The repository configures AeroSpace, Ghostty, Karabiner, Neovim, Starship,
tmux, zoxide, zsh, Git, Codex, and Claude Code. It includes no account,
workplace, or repository-specific configuration.
