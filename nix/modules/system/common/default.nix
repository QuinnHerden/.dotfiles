{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./fonts
    ./nix
    ./packages
  ];

}
