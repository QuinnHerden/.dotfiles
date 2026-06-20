#!/bin/bash
set -e

# --- Populate home from skel ---
# The launcher bind-mounts the host box dir directly as /home/dev. On first
# boot the dir is nearly empty; copy the image's skeleton (Nix profile,
# dotfiles, home-manager state) into it. On subsequent boots, existing files
# are left alone (--ignore-existing) so user state is preserved. New files
# added by an image rebuild are picked up on the next restart.
if [ -d /home/dev.skel ]; then
  echo "Syncing home from skel..." >&2
  rsync -rlD --ignore-existing /home/dev.skel/ /home/dev/
  echo "Home ready." >&2
fi

# --- Init dotfiles git repo ---
# The image's .dotfiles is a plain copy (.git is excluded by .containerignore).
# Clone on first boot so git pull + hm-switch work inside the container.
if [ -d /home/dev/.dotfiles ] && [ ! -d /home/dev/.dotfiles/.git ]; then
  echo "Initializing dotfiles repo..." >&2
  tmp=$(mktemp -d -p /home/dev)
  if git clone --bare https://github.com/QuinnHerden/.dotfiles.git "$tmp"; then
    if mv "$tmp" /home/dev/.dotfiles/.git; then
      git -C /home/dev/.dotfiles config core.bare false
      git -C /home/dev/.dotfiles reset HEAD
      git -C /home/dev/.dotfiles checkout -- .
      echo "Dotfiles repo ready." >&2
    else
      rm -rf "$tmp"
      echo "Dotfiles repo init failed (could not move .git into place)." >&2
    fi
  else
    rm -rf "$tmp"
    echo "Dotfiles repo init skipped (clone failed, will retry next boot)." >&2
  fi
fi

# Source Nix
if [ -f /home/dev/.nix-profile/etc/profile.d/nix.sh ]; then
  # shellcheck disable=SC1091  # sourced at runtime, not available to the linter
  . /home/dev/.nix-profile/etc/profile.d/nix.sh
fi

# Writable npm global prefix (Nix store is read-only)
export NPM_CONFIG_PREFIX=/home/dev/.npm-global
export PATH="/home/dev/.npm-global/bin:$PATH"
mkdir -p /home/dev/.npm-global

# Link external mounts into home. These are mounted outside /home/dev (at
# /run/*) so the bind mount doesn't shadow them.
[ -d /run/npm-cache ] && ln -sfn /run/npm-cache /home/dev/.npm

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
if [ -d /run/claude-memory ]; then
  rm -rf "$CCDIR/memory"
  ln -sfn /run/claude-memory "$CCDIR/memory"
fi

# Claude knowledge library, mounted read-only from the host's private submodule
# (see the dev launcher). The agents reference ~/.claude/knowledge by literal
# path, while Claude reads its config from CLAUDE_CONFIG_DIR, so link it into
# both. Skipped when the mount is absent (e.g. a fork without the submodule).
# ~/.claude/knowledge is unmanaged by home-manager since #177; if it is ever
# re-added to home.file, this rm -rf would clobber the managed copy.
if [ -d /run/claude-knowledge ]; then
  for kdst in "$HOME/.claude/knowledge" "${CCDIR:?}/knowledge"; do
    mkdir -p "$(dirname "$kdst")"
    rm -rf "$kdst"
    ln -sfn /run/claude-knowledge "$kdst"
  done
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
