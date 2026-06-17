# .dotfiles

[![CI](https://github.com/QuinnHerden/.dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/QuinnHerden/.dotfiles/actions/workflows/ci.yml) [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

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

```mermaid
graph TD
  hm["home-manager"]
  flake["nix/flake.nix"]

  flake --> darwin["darwinConfigurations: mac-papi"]
  flake --> nixos["nixosConfigurations: nix-box, nix-dots"]
  flake --> home["homeConfigurations: dev@dev-container, quinnherden@kali-bug"]

  hm -. "as a module" .-> darwin
  hm -. "as a module" .-> nixos
  hm -. "builds" .-> home

  darwin --> sysd["modules/system: common + darwin"]
  nixos --> sysn["modules/system: common + nixos"]
  darwin --> mhi["modules/home/integrated"]
  nixos --> mhi
  home --> mhs["modules/home/standalone"]

  mhi --> mhc["modules/home/content"]
  mhs --> mhc
  sysd --> pkg["modules/packages"]
  sysn --> pkg
  mhi --> pkg
  mhs --> pkg
```

The host matrix. Each flake output is a machine. home-manager is embedded as a module in the darwin and NixOS systems, and it builds the two standalone home configs. The darwin and NixOS hosts compose `modules/system` plus `modules/home/integrated`; the standalone home configs use only `modules/home/standalone`. Both home layers share `modules/home/content`, and the system and home package wrappers draw from `modules/packages`.

## Start here (reading, not installing)

1. `nix/flake.nix`, the host matrix. See how each machine maps to a set of modules.
2. `nix/hosts/dev-container/`, the smallest and most self-contained host. The best first example.
3. `files/scripts/dev`, the Podman dev-container wrapper.
4. `files/home/.claude/`, the Claude Code setup (below).

## The Claude Code setup

Likely the most reusable part of this repo. `files/home/.claude/` holds:

- **agents/**: focused specialist subagents (system-architect, security-analyst, code-reviewer, data-engineer, cloud-platform, process-analyst, plus GTM, brand, and UX specialists). Each carries compressed named frameworks inline and a `Reference Library` pointer to the deeper source material.
- **skills/**: repeatable procedures (extracting book knowledge into the knowledge base, stress-testing an agent, and more).
- **knowledge/**: a 20/80 extraction library that backs the agents. It is a *private* git submodule, since the extractions distill copyrighted source material, so it will not populate on a public clone. That is intentional, not a broken repo.

## Install (reinstalling on a new machine)

This is the runbook for setting up a machine, written for me. The host config is keyed by hostname, so the hostname must match an entry before `.switch` will resolve.

### 1. Prerequisites

On macOS, install Nix:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

On NixOS, get online and make git available:

```bash
nmcli d wifi list
nmcli d wifi connect {ssid} --ask
nix-shell -p git
```

On generic Linux (non-NixOS), set the hostname and make sure curl is present:

```bash
sudo hostname {hostname}        # e.g. kali-bug
sudo apt install curl           # or your distro's equivalent
```

### 2. Clone

```bash
cd ~/
git clone https://github.com/QuinnHerden/.dotfiles.git
```

### 3. Init

Run the bootstrap script. It is not idempotent in one pass; run it repeatedly until it exits 0.

```bash
sh ~/.dotfiles/files/scripts/.init
```

### 4. Set hostname

The hostname selects which host config to sync to.

```bash
sudo hostname {hostname}        # NixOS / macOS
```

On generic Linux this is already done from step 1. There, `.switch` resolves the `homeConfigurations` entry from `$(whoami)@$(hostname)`.

### 5. Switch

Apply the config:

```bash
sh ~/.dotfiles/files/scripts/.switch
```

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

The first start installs Claude Code via npm and takes a few seconds. Subsequent starts are near-instant, since the npm cache persists in a named volume.

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
