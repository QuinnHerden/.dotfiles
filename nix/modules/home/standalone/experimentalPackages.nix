{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../packages/experimental.nix;
in

{

  options.experimentalPackages.enable = lib.mkEnableOption "enables experimentalPackages";

  config = lib.mkIf config.experimentalPackages.enable {
    home.packages =
      (pkg.common pkgs) ++
      (pkg.linux pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (pkg.linuxX86 pkgs));
  };

}
