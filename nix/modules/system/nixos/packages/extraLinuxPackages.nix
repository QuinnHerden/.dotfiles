{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    extraLinuxPackages = {
      enable = lib.mkEnableOption "enables extraLinuxPackages";
    };
  };

  config = lib.mkIf config.extraLinuxPackages.enable {
    environment.systemPackages =
      (import ../../../packages/extraLinux.nix pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (import ../../../packages/extraLinuxX86.nix pkgs));
  };

}
