{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../packages/sec.nix;
in

{

  options.secPackages.enable = lib.mkEnableOption "enables secPackages";

  config = lib.mkIf config.secPackages.enable {
    home.packages =
      (pkg.common pkgs) ++
      (pkg.linux pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (pkg.linuxX86 pkgs));
  };

}
