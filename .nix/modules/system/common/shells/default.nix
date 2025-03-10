{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./defaultShell.nix
  ];
  
  defaultShell.enable = lib.mkDefault true;

}