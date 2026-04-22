{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    opsLinuxPackages = {
      enable = lib.mkEnableOption "enables opsLinuxPackages";
    };
  };

  config = lib.mkIf config.opsLinuxPackages.enable {
    environment.systemPackages =
      (import ../../../../packages/opsLinux.nix pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (import ../../../../packages/opsLinuxX86.nix pkgs));
  };

}
