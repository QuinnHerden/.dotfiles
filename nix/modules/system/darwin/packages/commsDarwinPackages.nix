{
  lib,
  config,
  pkgs,
  ...
}:

let
  packages = import ../../../packages/commsDarwin.nix;
in

{

  options = {
    commsDarwinPackages = {
      enable = lib.mkEnableOption "enables commsDarwinPackages";
    };
  };

  config = lib.mkIf config.commsDarwinPackages.enable {
    homebrew = {
      brews = packages.brews;
      casks = packages.casks;
      masApps = packages.masApps;
    };
  };

}
