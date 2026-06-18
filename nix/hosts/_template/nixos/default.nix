# Generic NixOS workstation template. To add a machine:
#   1. Copy this directory to hosts/<name>/.
#   2. Replace hardware-configuration.nix with `nixos-generate-config` output.
#   3. Set hostname.name and the package-category toggles below.
#   4. Add an entry under hosts.nixos in flake.nix.
# Note: the user is still quinnherden (from the shared base); full username
# parameterization is a tracked follow-up to #148.
_:

{
  imports = [
    ./hardware-configuration.nix
    ../../_shared/nixos-workstation.nix
  ];

  hostname.name = "template-nixos";

  ############
  # packages #
  ############
  opsPackages.enable = true;
}
