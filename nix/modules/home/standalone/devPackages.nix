{
  lib,
  config,
  pkgs,
  ...
}:

let
  pkg = import ../../packages/dev.nix;
in

{

  # Scope: USER. Installs into home.packages (home-manager). The identically
  # named NixOS module installs into environment.systemPackages instead; the two
  # never coexist on one host. See #129.
  options.devPackages.enable = lib.mkEnableOption "enables devPackages";

  config = lib.mkIf config.devPackages.enable {
    home.packages =
      (pkg.common pkgs) ++ (pkg.linux pkgs) ++ (lib.optionals pkgs.stdenv.isx86_64 (pkg.linuxX86 pkgs));
  };

}
