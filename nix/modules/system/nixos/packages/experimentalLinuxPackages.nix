{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    experimentalLinuxPackages = {
      enable = lib.mkEnableOption "enables experimentalLinuxPackages";
    };
  };

  config = lib.mkIf config.experimentalLinuxPackages.enable {
    environment.systemPackages =
      (import ../../../packages/experimentalLinux.nix pkgs) ++
      (lib.optionals pkgs.stdenv.isx86_64 (import ../../../packages/experimentalLinuxX86.nix pkgs));
  };

}
