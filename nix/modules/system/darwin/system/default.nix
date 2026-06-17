{
  lib,
  ...
}:

{

  imports = [
    ./darwinSystem.nix
  ];

  darwinSystem.enable = lib.mkDefault true;

}
