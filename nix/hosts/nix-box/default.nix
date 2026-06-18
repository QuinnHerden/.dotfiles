{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../_shared/nixos-workstation.nix
  ];

  hostname.name = "nix-box";
  user.name = "quinnherden";

  ############
  # packages #
  ############
  opsPackages.enable = true;
}
