{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./sharedBrews.nix
  ];
  
  sharedBrews.enable = lib.mkDefault true;

}