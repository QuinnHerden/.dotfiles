# .dotfiles

A curated collection of personal system configurations.
Enabling a seamless experience across host environments.

## Prerequisites

### On MacOS

#### Install Nix

- `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`

### On All

#### Connect to the Internet

##### NixOS

- `nmcli d wifi list`
- `nmcli d wifi connect {ssis} --ask`

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

set your hostname to match the host config you want to sync to.

- `sudo hostname {hostname}`

### Configure System

- run `sh ~/.dotfiles/files/scripts/.switch` to configure your system.

## Post Installation

### MacOS Manual Configurations

- [Configurations](manual-configurations.md)

