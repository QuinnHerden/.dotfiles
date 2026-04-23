{
  lib,
  config,
  pkgs,
  ...
}:

let
  packages = import ../../../packages/extraDarwin.nix;
in

{

  options = {
    extraDarwinPackages = {
      enable = lib.mkEnableOption "enables extraDarwinPackages";
    };
  };

  config = lib.mkIf config.extraDarwinPackages.enable {
    homebrew = {
      brews = packages.brews;
      casks = packages.casks;
      masApps = packages.masApps;
    };
  };

}
