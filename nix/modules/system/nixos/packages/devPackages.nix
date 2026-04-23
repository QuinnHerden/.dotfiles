{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../../packages/dev.nix;
in

{

  options.devPackages.enable = lib.mkEnableOption "enables devPackages";

  config = lib.mkIf config.devPackages.enable {
    environment.systemPackages =
      (pkg.common pkgs) ++
      (pkg.linux pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (pkg.linuxX86 pkgs));
  };

}
