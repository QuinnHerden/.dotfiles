# /files

Configurations replicated on each of my hosts: app dotfiles (`config/`), home-level files (`home/`, including the Claude Code setup), and scripts (`scripts/`).

## How these files are applied

These files are not copied into the Nix store. The home-manager content modules map them with `mkOutOfStoreSymlink`, so the deployed path is a symlink straight to this clone:

- `nix/modules/home/content/base.nix` — portable core (gitconfig, tmux, `.claude/`, nvim, scripts).
- `nix/modules/home/content/linux.nix` — Linux-only (i3, rofi, qutebrowser, background).
- `nix/modules/home/content/darwin.nix` — macOS-only.

Because the deployed file is a live symlink, **editing a file here takes effect immediately; you do not rebuild.** A rebuild is only needed to add or remove a managed entry.

## Modification

- To change a file's contents: edit it here. Done.
- To start managing a new file (or stop): add or remove its `mkOutOfStoreSymlink` entry in the matching `content/*.nix` module, then run `.switch`.

### References

- [home-manager `home.file`](https://mynixos.com/home-manager/options/home.file.%3Cname%3E)
- [`mkOutOfStoreSymlink` background](https://www.reddit.com/r/NixOS/comments/vh2kf7/comment/id58mw3/)
