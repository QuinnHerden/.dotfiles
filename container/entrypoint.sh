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

# Wire up Claude config + state.
# CLAUDE_CONFIG_DIR (set in the image) points Claude at the per-container
# persistent mount, so everything it writes (credentials, .claude.json,
# sessions, projects, todos, history) survives container recreation and you
# authenticate once. This relies on CLAUDE_CONFIG_DIR relocating the whole
# config dir (verified empirically; the scope is only partly documented
# upstream). The static config is symlinked in from the dotfiles clone, so
# editing ~/.dotfiles is live; new files are picked up on the next start.
# We re-establish each link from scratch so a stale real file/dir at the target
# (e.g. one Claude wrote, or a pre-existing dir) can't shadow the symlink.
CCDIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
mkdir -p "$CCDIR"; chmod 700 "$CCDIR" 2>/dev/null || true
DOT=/home/dev/.dotfiles/files/home/.claude
if [ -d "$DOT" ]; then
  for f in "$DOT"/*; do
    [ -e "$f" ] || continue
    name=$(basename "$f")
    rm -rf "$CCDIR/$name"
    ln -sfn "$f" "$CCDIR/$name"
  done
fi

# Global (user-level) Claude memory is shared across all containers (mounted by
# the launcher), not per-container like the rest of the config dir.
if [ -d /home/dev/.claude-memory ]; then
  rm -rf "$CCDIR/memory"
  ln -sfn /home/dev/.claude-memory "$CCDIR/memory"
fi

# Persist gh CLI auth in the per-container state so it survives recreation. git
# uses `gh auth git-credential`, so this fixes git auth too.
if [ -d /home/dev/.dev-state ]; then
  mkdir -p /home/dev/.dev-state/config/gh "$HOME/.config"
  chmod 700 /home/dev/.dev-state/config/gh 2>/dev/null || true
  rm -rf "$HOME/.config/gh"
  ln -sfn /home/dev/.dev-state/config/gh "$HOME/.config/gh"
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
