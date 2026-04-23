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
    environment.systemPackages =
      (pkg.common pkgs) ++
      (pkg.linux pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (pkg.linuxX86 pkgs));
  };

}
