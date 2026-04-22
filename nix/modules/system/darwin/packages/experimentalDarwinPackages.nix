{
  lib,
  config,
  pkgs,
  ...
}:

let
  packages = import ../../../packages/experimentalDarwin.nix;
in

{

  options = {
    experimentalDarwinPackages = {
      enable = lib.mkEnableOption "enables experimentalDarwinPackages";
    };
  };

  config = lib.mkIf config.experimentalDarwinPackages.enable {
    homebrew = {
      brews = packages.brews;
      casks = packages.casks;
      masApps = packages.masApps;
    };
  };

}
