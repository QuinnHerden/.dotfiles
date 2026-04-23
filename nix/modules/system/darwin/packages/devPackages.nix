{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../../packages/dev.nix;
in

{

  options.devPackages.enable = lib.mkEnableOption "enables devPackages";

  config = lib.mkIf config.devPackages.enable {
    environment.systemPackages = pkg.common pkgs;
    homebrew = {
      brews = pkg.darwin.brews;
      casks = pkg.darwin.casks;
      masApps = pkg.darwin.masApps;
    };
  };

}
