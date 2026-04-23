{
  lib,
  config,
  pkgs,
  ...
}:

{

  nixpkgs.config.allowUnfree = true;

  imports = [
    ../content/base.nix
    ./commsPackages.nix
    ./devPackages.nix
    ./experimentalPackages.nix
    ./extraPackages.nix
    ./infraPackages.nix
    ./opsPackages.nix
    ./secPackages.nix
  ];

}
