{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    experimentalLinuxX86Packages = {
      enable = lib.mkEnableOption "enables experimentalLinuxX86Packages";
    };
  };

  config = lib.mkIf config.experimentalLinuxX86Packages.enable {
    home.packages = import ../../packages/experimentalLinuxX86.nix pkgs;
  };

}
