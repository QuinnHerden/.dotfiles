{
  lib,
  ...
}:

{

  imports = [
    ./darwinSystem.nix
    ./primaryUser.nix
  ];

  darwinSystem.enable = lib.mkDefault true;

}
