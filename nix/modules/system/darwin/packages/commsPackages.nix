{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../../packages/comms.nix;
in

{

  options.commsPackages.enable = lib.mkEnableOption "enables commsPackages";

  config = lib.mkIf config.commsPackages.enable {
    environment.systemPackages = pkg.common pkgs;
    homebrew = {
      inherit (pkg.darwin) brews casks masApps;
    };
  };

}
