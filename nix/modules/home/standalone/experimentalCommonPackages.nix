{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    experimentalCommonPackages = {
      enable = lib.mkEnableOption "enables experimentalCommonPackages";
    };
  };

  config = lib.mkIf config.experimentalCommonPackages.enable {
    home.packages = import ../../packages/experimentalCommon.nix pkgs;
  };

}
