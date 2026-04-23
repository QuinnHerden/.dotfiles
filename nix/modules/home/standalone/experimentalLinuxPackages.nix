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
    home.packages = import ../../packages/experimentalLinux.nix pkgs;
  };

}
