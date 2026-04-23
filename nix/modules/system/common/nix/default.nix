{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./experimentalFeatures.nix
  ];

  experimentalFeatures.enable = lib.mkDefault true;

  nixpkgs.config.allowUnfree = true;

}
