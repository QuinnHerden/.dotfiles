# Generic NixOS workstation template. To add a machine:
#   1. Copy this directory to hosts/<name>/.
#   2. Replace hardware-configuration.nix with `nixos-generate-config` output.
#   3. Set hostname.name and the package-category toggles below.
#   4. Add an entry under hosts.nixos in flake.nix.
#   5. Replace the bootstrap login below with your own SSH key or password.
{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../_shared/nixos-workstation.nix
  ];

  hostname.name = "template-nixos";
  user.name = "user";

  # BOOTSTRAP LOGIN (placeholder) -- without this a fresh fork builds a host it
  # cannot log into: the primary user has no password, and authorized SSH keys
  # come from the owner's private overlay (inputs.private) that a fork lacks.
  # `initialPassword` applies only at first user creation and is meant to be
  # changed. CHANGE THIS before any real use: supply your own SSH key via a
  # private overlay, or set `hashedPassword` (mkpasswd -m sha-512) instead.
  # Do not ship this as-is. The owner's real hosts do not set this.
  users.users.${config.user.name}.initialPassword = "changeme";

  ############
  # packages #
  ############
  opsPackages.enable = true;
}
