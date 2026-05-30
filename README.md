# .dotfiles

A curated collection of personal system configurations.
Enabling a seamless experience across host environments.

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
- **Generic Linux:** already done in prerequisites — `.switch` uses `$(whoami)@$(hostname)` to resolve your `homeConfigurations` entry

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
# Bare mode — drops into an interactive dev shell, no repo
dev

# Project mode — clones the branch, maps ports, starts as daemon
dev ~/repos/myproject
dev ~/repos/myproject feat/my-branch

# Attach to a running project container
podman exec -it dev-myproject-main zsh

# Stop and remove a container
dev --stop dev-myproject-main

# Rebuild the image (after dotfiles changes)
dev --rebuild
```

The first start takes ~15 seconds to install Claude Code via npm. Subsequent starts are near-instant (npm cache persists in a named volume).

### Project config

Add a `dev.yml` to any repo to configure compose files and port mappings:

```yaml
project: myproject
compose_dir: docker
compose_files:
  - docker-compose.yml
  - docker-compose.dev.yml
ports:
  pg: 5432
  api: 8080
  web: 5173
```

Ports are auto-offset per container so parallel instances don't collide.

### Parallel development

Spin up multiple containers for different branches — each gets its own clone, database, and app stack:

```bash
dev ~/repos/myproject feat/branch-a
dev ~/repos/myproject feat/branch-b
# Two fully isolated environments
```


## Post Installation

### MacOS Manual Configurations

- [Configurations](manual-configurations.md)

