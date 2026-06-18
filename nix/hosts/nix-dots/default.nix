{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../_shared/nixos-workstation.nix
  ];

  hostname.name = "nix-dots";
  user.name = "quinnherden";

  ############
  # packages #
  ############
  opsPackages.enable = true;
  devPackages.enable = true;
  infraPackages.enable = true;
  secPackages.enable = true;
  commsPackages.enable = true;
  extraPackages.enable = true;
}
