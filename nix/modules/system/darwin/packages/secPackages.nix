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
      inherit (pkg.darwin) brews casks masApps;
    };
  };

}
