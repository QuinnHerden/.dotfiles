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

  # Scope: SYSTEM. Installs into environment.systemPackages. The identically
  # named home-manager module installs into home.packages instead; the two never
  # coexist on one host. See #129.
  options.devPackages.enable = lib.mkEnableOption "enables devPackages";

  config = lib.mkIf config.devPackages.enable {
    environment.systemPackages =
      (pkg.common pkgs) ++ (pkg.linux pkgs) ++ (lib.optionals pkgs.stdenv.isx86_64 (pkg.linuxX86 pkgs));
  };

}
