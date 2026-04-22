{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./commonBaseHome.nix
    ./darwinBaseHome.nix
    ./linuxBaseHome.nix
  ];

}
