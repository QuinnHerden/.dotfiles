{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./devDarwinPackages.nix
    ./opsDarwinPackages.nix
    ./experimentalDarwinPackages.nix
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
  };

}
