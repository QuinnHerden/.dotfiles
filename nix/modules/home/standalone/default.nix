{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ../content/base.nix
    ../content/linux.nix
    ./commonPackages.nix
    ./linuxPackages.nix
  ];

}
