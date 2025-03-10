{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./homebrew
    ./networking
    ./packages
    ./system
  ];
  
}