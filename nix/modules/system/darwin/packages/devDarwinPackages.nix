{
  lib,
  config,
  pkgs,
  ...
}:

let
  packages = import ../../../packages/devDarwin.nix;
in

{

  options = {
    devDarwinPackages = {
      enable = lib.mkEnableOption "enables devDarwinPackages";
    };
  };

  config = lib.mkIf config.devDarwinPackages.enable {
    homebrew = {
      brews = packages.brews;
      casks = packages.casks;
      masApps = packages.masApps;
    };
  };

}
