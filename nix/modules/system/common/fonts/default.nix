{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./commonFonts.nix
  ];
  
  commonFonts.enable = lib.mkDefault true;

}