{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./darwinPackages.nix
    ./linuxPackages.nix
    ./sharedPackages.nix
  ];

  sharedPackages.enable = lib.mkDefault true;

}