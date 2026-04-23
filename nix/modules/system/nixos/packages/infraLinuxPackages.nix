{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    infraLinuxPackages = {
      enable = lib.mkEnableOption "enables infraLinuxPackages";
    };
  };

  config = lib.mkIf config.infraLinuxPackages.enable {
    environment.systemPackages =
      (import ../../../packages/infraLinux.nix pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (import ../../../packages/infraLinuxX86.nix pkgs));
  };

}
