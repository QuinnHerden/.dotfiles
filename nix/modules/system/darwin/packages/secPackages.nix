{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../../packages/sec.nix;
in

{

  options.secPackages.enable = lib.mkEnableOption "enables secPackages";

  config = lib.mkIf config.secPackages.enable {
    environment.systemPackages = pkg.common pkgs;
    homebrew = {
      brews = pkg.darwin.brews;
      casks = pkg.darwin.casks;
      masApps = pkg.darwin.masApps;
    };
  };

}
