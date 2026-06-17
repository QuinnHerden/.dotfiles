{
  lib,
  ...
}:

{

  imports = [
    ./commonFonts.nix
  ];

  commonFonts.enable = lib.mkDefault true;

}
