{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    devLinuxPackages = {
      enable = lib.mkEnableOption "enables devLinuxPackages";
    };
  };

  config = lib.mkIf config.devLinuxPackages.enable {
    environment.systemPackages =
      (import ../../../packages/devLinux.nix pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (import ../../../packages/devLinuxX86.nix pkgs));
  };

}
