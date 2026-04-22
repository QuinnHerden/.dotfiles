{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ../content/base.nix
    ./commonPackages.nix
    ./linuxPackages.nix
  ];

}
