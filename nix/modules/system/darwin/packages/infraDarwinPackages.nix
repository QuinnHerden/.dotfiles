{
  lib,
  config,
  pkgs,
  ...
}:

let
  packages = import ../../../packages/infraDarwin.nix;
in

{

  options = {
    infraDarwinPackages = {
      enable = lib.mkEnableOption "enables infraDarwinPackages";
    };
  };

  config = lib.mkIf config.infraDarwinPackages.enable {
    homebrew = {
      brews = packages.brews;
      casks = packages.casks;
      masApps = packages.masApps;
    };
  };

}
