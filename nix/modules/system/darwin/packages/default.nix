{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./commsPackages.nix
    ./devPackages.nix
    ./experimentalPackages.nix
    ./extraPackages.nix
    ./infraPackages.nix
    ./opsPackages.nix
    ./secPackages.nix
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
  };

}
