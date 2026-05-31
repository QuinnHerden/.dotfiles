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
# Create a named container
dev myproject

# Shell into it
dev --exec myproject

# Inside the container: clone, install, run
git clone https://github.com/org/myproject.git
cd myproject
make install
make upd

# Manage containers
dev --ls                     # list running dev containers
dev --stop myproject         # stop and remove
dev --restart myproject      # stop + recreate
dev --rebuild                # rebuild the image (after dotfiles changes)
```

The first start takes ~15 seconds to install Claude Code via npm. Subsequent starts are near-instant (npm cache persists in a named volume).

Sibling containers (postgres, backend, etc.) started via `make upd` bind their ports directly — no port config needed.

### Parallel development

Spin up multiple containers for parallel work:

```bash
dev feature-a
dev feature-b
# Two fully isolated environments, each with their own repo clone and app stack
```


## Post Installation

### MacOS Manual Configurations

- [Configurations](manual-configurations.md)

