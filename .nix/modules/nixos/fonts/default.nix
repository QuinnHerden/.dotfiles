{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./sharedFonts.nix
  ];
  
  sharedFonts.enable = lib.mkDefault true;

}