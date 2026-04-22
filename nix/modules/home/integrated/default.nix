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
    ./nixosBaseHome.nix
  ];

}
