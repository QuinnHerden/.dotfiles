{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./x86_64-linuxSystem.nix
    ./aarch64-linuxSystem.nix
  ];
  
}
