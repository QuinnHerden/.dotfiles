{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./devLinuxPackages.nix
    ./opsLinuxPackages.nix
    ./secLinuxPackages.nix
  ];

}
