# .dotfiles

A curated collection of personal system configurations.
Enabling a seamless experience across host environments.

## Prerequisites

1. Ensure `git` is installed on your system.
2. Ensure `git` is in your path.

## Installation

### set hostname

set your hostname to match the host config you want to sync to.

### install nix

`curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install`

### navigate home

`cd ~/`

### clone repo

`git clone https://github.com/QuinnHerden/.dotfiles.git`

### init system

run `sh ~/.dotfiles/files/scripts/dinit` repeatedly until you receive a successful exit status.

### init system

run `sh ~/.dotfiles/files/scripts/dconf` to configure your system.

#### manual configurations

[Configurations](manual-configurations.md)
