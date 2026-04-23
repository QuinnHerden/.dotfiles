{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../../packages/extra.nix;
in

{

  options.extraPackages.enable = lib.mkEnableOption "enables extraPackages";

  config = lib.mkIf config.extraPackages.enable {
    environment.systemPackages = pkg.common pkgs;
    homebrew = {
      brews = pkg.darwin.brews;
      casks = pkg.darwin.casks;
      masApps = pkg.darwin.masApps;
    };
  };

}
