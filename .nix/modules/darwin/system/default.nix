{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./sharedSystem.nix
  ];
  
  sharedSystem.enable = lib.mkDefault true;

}