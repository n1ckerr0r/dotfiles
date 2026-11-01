# Dotfiles

This repository is the source of truth for editable application settings.
`../dotfiles.nix` contains their mapping to standard locations under the home
directory.

Home Manager uses `mkOutOfStoreSymlink`, so applications read these files
directly instead of immutable copies from `/nix/store`. Editing a linked file
therefore edits the checked-out dotfile.

Package installation, services, generated helper scripts, and settings that
depend on Nix store paths remain in Nix modules.

## Nested repositories

`vscode/` and `nvim/` are independent Git submodules. Commit changes in those
repositories first, then commit their new revisions here. This dotfiles
repository is itself a submodule of `nixos-configuration`.

VS Code settings and keybindings are linked into `~/.config/Code/User`. Runtime
state, extensions, profiles, history and caches remain outside Git.

## GTK

GTK settings are generated declaratively by `desktop/gtk.nix`. Only the dconf
interface values are sourced from `gtk/dconf-interface.json`. OBS runtime state
is deliberately not linked because OBS atomically replaces its configuration
file and would break an editable symlink.

## Zsh

`zsh/` is linked as `~/.config/zsh`, and `zsh/.zshenv` is also linked as
`~/.zshenv` to bootstrap `ZDOTDIR`. The interactive config remains
`zsh/.zshrc`, so the editable source for zsh lives in one dotfiles directory.

Runtime caches, generated completion dumps, logs and `*.hm-backup` files must
not be committed.
