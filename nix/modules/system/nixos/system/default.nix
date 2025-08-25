{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./commonSystem.nix
  ];
  
  commonSystem.enable = lib.mkDefault false;

}
