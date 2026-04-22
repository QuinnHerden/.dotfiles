{
  lib,
  config,
  pkgs,
  ...
}:

let
  packages = import ../../../packages/opsDarwin.nix;
in

{

  options = {
    opsDarwinPackages = {
      enable = lib.mkEnableOption "enables opsDarwinPackages";
    };
  };

  config = lib.mkIf config.opsDarwinPackages.enable {
    homebrew = {
      brews = packages.brews;
      casks = packages.casks;
      masApps = packages.masApps;
    };
  };

}
