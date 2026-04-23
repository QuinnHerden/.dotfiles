{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./commsDarwinPackages.nix
    ./devDarwinPackages.nix
    ./experimentalDarwinPackages.nix
    ./extraDarwinPackages.nix
    ./infraDarwinPackages.nix
    ./opsDarwinPackages.nix
    ./secDarwinPackages.nix
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
  };

}
