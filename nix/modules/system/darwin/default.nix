{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./networking
    ./packages
    ./system
  ];
  
}