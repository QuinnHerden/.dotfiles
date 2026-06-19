#!/bin/bash
set -e

# Source Nix
if [ -f /home/dev/.nix-profile/etc/profile.d/nix.sh ]; then
  # shellcheck disable=SC1091  # sourced at runtime, not available to the linter
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
    rm -rf "${CCDIR:?}/$name"
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

# Fix git credential helper for container context. Resolve gh lazily at git
# runtime (it is on PATH when git invokes the helper) and only set it if present,
# so an absent gh does not leave a broken `!  auth git-credential` helper.
if command -v gh >/dev/null 2>&1; then
  git config --global credential.helper "!gh auth git-credential"
else
  git config --global --unset-all credential.helper 2>/dev/null || true
fi

# Install/repair Claude Code (runtime install — cached via npm prefix volume).
# Intentionally tracks @latest (#125): Claude Code ships frequently and we want
# the newest CLI, so the image is deliberately not a frozen artifact for this one
# component (the Nix toolchain is pinned). Bump by restarting the container.
# claude-code ships a JS stub plus a platform-native optional dependency that is
# fetched by its postinstall; an interrupted or optional-omitting install leaves
# `claude` on PATH but non-functional. So verify it actually *runs* (not just
# that the symlink exists), and (re)install with optional deps if missing/broken.
if ! claude --version >/dev/null 2>&1; then
  echo "Installing/repairing Claude Code..."
  npm install -g --include=optional @anthropic-ai/claude-code@latest || true
  if ! claude --version >/dev/null 2>&1; then
    echo "WARNING: Claude Code installed but not runnable — native binary missing." >&2
    echo "  Retry: npm install -g --include=optional @anthropic-ai/claude-code@latest" >&2
  fi
fi

# Detached mode: stay alive for exec sessions.
# Interactive mode: drop into shell.
if [ "${DEV_DETACHED:-}" = "1" ]; then
  exec sleep infinity
else
  exec zsh
fi
