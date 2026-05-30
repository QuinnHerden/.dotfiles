#!/bin/bash
set -e

# Source Nix
if [ -f /home/dev/.nix-profile/etc/profile.d/nix.sh ]; then
  . /home/dev/.nix-profile/etc/profile.d/nix.sh
fi

# XDG_RUNTIME_DIR for rootless podman
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
sudo mkdir -p "$XDG_RUNTIME_DIR"
sudo chown dev:dev "$XDG_RUNTIME_DIR"

# Fix git credential helper for container context
git config --global credential.helper "!$(which gh) auth git-credential"

# Start podman system service (for lazydocker)
podman system service --time=0 "unix://$XDG_RUNTIME_DIR/podman/podman.sock" &

# Install/update Claude Code (runtime install — cached via npm prefix volume)
if ! command -v claude >/dev/null 2>&1; then
  echo "Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code 2>/dev/null || true
fi

# Start inner app stack if compose config is provided
if [ -n "$COMPOSE_DIR" ] && [ -n "$COMPOSE_FILES" ]; then
  cd "$COMPOSE_DIR"
  COMPOSE_ARGS=""
  IFS=':' read -ra FILES <<< "$COMPOSE_FILES"
  for f in "${FILES[@]}"; do
    COMPOSE_ARGS="$COMPOSE_ARGS -f $f"
  done
  echo "Starting app stack..."
  podman compose $COMPOSE_ARGS up -d --build || echo "Warning: compose up failed (may need manual start)"
  cd /home/dev/project
fi

exec "$@"
