{
  lib,
  config,
  pkgs,
  ...
}:

let
  packages = import ../../../packages/secDarwin.nix;
in

{

  options = {
    secDarwinPackages = {
      enable = lib.mkEnableOption "enables secDarwinPackages";
    };
  };

  config = lib.mkIf config.secDarwinPackages.enable {
    homebrew = {
      brews = packages.brews;
      casks = packages.casks;
      masApps = packages.masApps;
    };
  };

}
