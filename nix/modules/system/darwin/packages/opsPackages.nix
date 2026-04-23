{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../../packages/ops.nix;
in

{

  options.opsPackages.enable = lib.mkEnableOption "enables opsPackages";

  config = lib.mkIf config.opsPackages.enable {
    environment.systemPackages = pkg.common pkgs;
    homebrew = {
      brews = pkg.darwin.brews;
      casks = pkg.darwin.casks;
      masApps = pkg.darwin.masApps;
    };
  };

}
