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
    ./system
  ];
  
}