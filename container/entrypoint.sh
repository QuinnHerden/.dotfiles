#!/bin/bash
set -e

# Source Nix
if [ -f /home/dev/.nix-profile/etc/profile.d/nix.sh ]; then
  . /home/dev/.nix-profile/etc/profile.d/nix.sh
fi

# Writable npm global prefix (Nix store is read-only)
export NPM_CONFIG_PREFIX=/home/dev/.npm-global
export PATH="/home/dev/.npm-global/bin:$PATH"
mkdir -p /home/dev/.npm-global

# Symlink mounted dir into home for convenience (e.g. ~/dev_0 -> /Users/.../containers/dev_0)
if [ -n "${DEV_MOUNT:-}" ] && [ -d "$DEV_MOUNT" ]; then
  LINK_NAME=$(basename "$DEV_MOUNT")
  [ ! -e "$HOME/$LINK_NAME" ] && ln -sfn "$DEV_MOUNT" "$HOME/$LINK_NAME"
fi

# Wire up persistent Claude state.
# home-manager (at build time) owns the static ~/.claude/* config as symlinks
# into ~/.dotfiles. Here we link the runtime-generated state subpaths to the
# mounted per-container state dir so memory, session history, todos and plugins
# persist on the host. We never touch the static config entries.
STATE=/home/dev/.claude-state
if [ -d "$STATE" ]; then
  mkdir -p "$HOME/.claude"
  for p in projects todos plugins; do
    mkdir -p "$STATE/$p"
    ln -sfn "$STATE/$p" "$HOME/.claude/$p"
  done
  [ -e "$STATE/history.jsonl" ] || : > "$STATE/history.jsonl"
  ln -sfn "$STATE/history.jsonl" "$HOME/.claude/history.jsonl"
fi

# Share the single canonical host credentials file (mounted by the launcher).
if [ -e /home/dev/.claude-cred.json ]; then
  mkdir -p "$HOME/.claude"
  ln -sfn /home/dev/.claude-cred.json "$HOME/.claude/.credentials.json"
  chmod 600 /home/dev/.claude-cred.json 2>/dev/null || true
fi

# Fix git credential helper for container context
git config --global credential.helper "!$(which gh) auth git-credential"

# Install/update Claude Code (runtime install — cached via npm prefix volume)
if ! command -v claude >/dev/null 2>&1; then
  echo "Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code || true
fi

# Detached mode: stay alive for exec sessions.
# Interactive mode: drop into shell.
if [ "${DEV_DETACHED:-}" = "1" ]; then
  exec sleep infinity
else
  exec zsh
fi
