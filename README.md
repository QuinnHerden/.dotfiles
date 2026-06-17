# .dotfiles

Personal Nix dotfiles: home-manager, nix-darwin, and NixOS across my Mac, my NixOS workstations, and a Podman dev container, plus a Claude Code setup (custom agents, skills, and a knowledge base).

> **This is my personal setup, not a template.** Hostnames, hosts, and secrets are mine, and the `knowledge/` submodule is private. Fork and adapt at your own pace; don't expect it to run clean on your machine. It is meant to be *read* for patterns, not cloned wholesale.

## What's in here

| Path | What it is |
|------|------------|
| `nix/flake.nix` | The host matrix. Every machine (darwin / NixOS / home-manager) is an output here. |
| `nix/hosts/` | Per-machine config: `dev-container`, `mac-papi`, `nix-box`, `nix-dots`, `kali-bug`. |
| `nix/modules/` | Shared building blocks (`home`, `system`, `packages`). Package data is centralized in `packages/` and consumed by thin per-platform wrappers. |
| `files/config/` | App dotfiles: nvim, i3, rofi, qutebrowser, karabiner. |
| `files/home/` | Home-level files, including `.claude/` (the Claude Code setup). |
| `files/scripts/` | Bootstrap (`.init`, `.switch`, `.update`) and the `dev` Podman wrapper. |
| `container/` | The dev-container image (Containerfile and entrypoint). |
| `.github/workflows/ci.yml` | CI: flake eval, lint, per-host builds, and a NixOS VM boot test. |

## Start here (reading, not installing)

1. `nix/flake.nix`, the host matrix. See how each machine maps to a set of modules.
2. `nix/hosts/dev-container/`, the smallest and most self-contained host. The best first example.
3. `files/scripts/dev`, the Podman dev-container wrapper.
4. `files/home/.claude/`, the Claude Code setup (below).

## The Claude Code setup

Probably the most reusable part of this repo. `files/home/.claude/` holds:

- **agents/**: focused specialist subagents (system-architect, security-analyst, code-reviewer, data-engineer, cloud-platform, process-analyst, plus GTM, brand, and UX specialists). Each carries compressed named frameworks inline and a `Reference Library` pointer to the deeper source material.
- **skills/**: repeatable procedures (extracting book knowledge into the knowledge base, stress-testing an agent, and more).
- **knowledge/**: a 20/80 extraction library that backs the agents. It is a *private* git submodule (the extractions distill copyrighted source material), so it will not populate on a public clone. That is intentional, not a broken repo.

## Prerequisites

### On MacOS

#### Install Nix

- `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`

### On Generic Linux (non-NixOS)

#### Set hostname to match your host config

- `sudo hostname {hostname}` (e.g. `kali-bug`)

#### Ensure curl is available

- `sudo apt install curl` or equivalent

### On All

#### Connect to the Internet

##### NixOS

- `nmcli d wifi list`
- `nmcli d wifi connect {ssid} --ask`

#### Ensure git is in your path

##### NixOS

- `nix-shell -p git`

## Installation

### Navigate Home

- `cd ~/`

### Clone Repo

- `git clone https://github.com/QuinnHerden/.dotfiles.git`

### Init System

- run `sh ~/.dotfiles/files/scripts/.init` repeatedly until you receive a successful exit status.

### Set hostname

Set your hostname to match the host config you want to sync to.

- **NixOS / MacOS:** `sudo hostname {hostname}`
- **Generic Linux:** already done in prerequisites; `.switch` uses `$(whoami)@$(hostname)` to resolve your `homeConfigurations` entry

### Configure System

- run `sh ~/.dotfiles/files/scripts/.switch` to configure your system.

## Dev Containers

Isolated dev environments using Podman. Each container gets the full dotfiles toolchain (zsh, nvim, lazygit, lazydocker, Claude Code) via Nix + home-manager.

### Prerequisites

1. Install [Podman Desktop](https://podman-desktop.io/)
2. Initialize and start the podman machine:
   ```bash
   podman machine init
   podman machine start
   ```
3. Build the dev container image:
   ```bash
   dev --rebuild
   ```

### Usage

```bash
# Create a container with a host directory mounted
dev work ~/repos

# Shell into it
dev --exec work

# Inside the container: repos are at ~/repos
cd ~/repos/motifs
make install && make upd     # compose volume paths resolve correctly

# Manage containers
dev --ls                     # list running dev containers
dev --stop work              # stop and remove
dev --restart work ~/repos   # stop + recreate
dev --rebuild                # rebuild the image (after dotfiles changes)
```

The mounted directory is available at the same host path inside the container, so `docker compose` volume mounts resolve correctly on the VM.

The first start takes ~15 seconds to install Claude Code via npm. Subsequent starts are near-instant (npm cache persists in a named volume).

### Parallel development

Mount the same directory into multiple containers for parallel branch work:

```bash
dev branch-a ~/repos
dev branch-b ~/repos
# Each container has its own shell, Claude instance, and compose stack
# but shares the same host repos (use separate branches/worktrees)
```


## Post Installation

### MacOS Manual Configurations

- [Configurations](manual-configurations.md)

## License

[MIT](LICENSE). This is a personal setup shared as a readable reference; use anything you find useful, no warranty.
