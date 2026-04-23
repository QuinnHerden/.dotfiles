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
    environment.systemPackages =
      (pkg.common pkgs) ++
      (pkg.linux pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (pkg.linuxX86 pkgs));
  };

}
