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
    environment.systemPackages =
      (pkg.common pkgs) ++
      (pkg.linux pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (pkg.linuxX86 pkgs));
  };

}
