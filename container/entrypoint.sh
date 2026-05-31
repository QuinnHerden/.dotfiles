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

# Symlink mounted host dirs into home for convenience (e.g. ~/repos -> /Users/.../repos)
for dir in /Users/*/repos /home/*/repos; do
  [ -d "$dir" ] && [ ! -e "$HOME/repos" ] && ln -sfn "$dir" "$HOME/repos" && break
done

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
