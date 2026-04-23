{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../../packages/experimental.nix;
in

{

  options.experimentalPackages.enable = lib.mkEnableOption "enables experimentalPackages";

  config = lib.mkIf config.experimentalPackages.enable {
    environment.systemPackages = pkg.common pkgs;
    homebrew = {
      brews = pkg.darwin.brews;
      casks = pkg.darwin.casks;
      masApps = pkg.darwin.masApps;
    };
  };

}
