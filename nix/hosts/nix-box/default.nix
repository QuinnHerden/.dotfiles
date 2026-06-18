{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../_shared/nixos-workstation.nix
  ];

  hostname.name = "nix-box";

  ############
  # packages #
  ############
  opsPackages.enable = true;
}
