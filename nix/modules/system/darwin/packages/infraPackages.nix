{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../../packages/infra.nix;
in

{

  options.infraPackages.enable = lib.mkEnableOption "enables infraPackages";

  config = lib.mkIf config.infraPackages.enable {
    environment.systemPackages = pkg.common pkgs;
    homebrew = {
      inherit (pkg.darwin) brews casks masApps;
    };
  };

}
