{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./darwinSystem.nix
  ];
  
  darwinSystem.enable = lib.mkDefault true;

}
