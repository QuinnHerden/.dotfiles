{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    secLinuxPackages = {
      enable = lib.mkEnableOption "enables secLinuxPackages";
    };
  };

  config = lib.mkIf config.secLinuxPackages.enable {
    environment.systemPackages =
      (import ../../../packages/secLinux.nix pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (import ../../../packages/secLinuxX86.nix pkgs));
  };

}
