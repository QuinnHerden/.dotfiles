{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    infraCommonPackages = {
      enable = lib.mkEnableOption "enables infraCommonPackages";
    };
  };

  config = lib.mkIf config.infraCommonPackages.enable {
    home.packages = import ../../packages/infraCommon.nix pkgs;
  };

}
