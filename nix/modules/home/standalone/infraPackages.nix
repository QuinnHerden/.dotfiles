{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../packages/infra.nix;
in

{

  options.infraPackages.enable = lib.mkEnableOption "enables infraPackages";

  config = lib.mkIf config.infraPackages.enable {
    home.packages =
      (pkg.common pkgs) ++
      (pkg.linux pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (pkg.linuxX86 pkgs));
  };

}
