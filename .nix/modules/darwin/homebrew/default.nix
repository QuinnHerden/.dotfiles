{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./baseBrews.nix
    ./experimentalBrews.nix
    ./extraBrews.nix
  ];
  
  baseBrews.enable = lib.mkDefault true;

}