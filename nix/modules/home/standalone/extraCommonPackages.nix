{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    extraCommonPackages = {
      enable = lib.mkEnableOption "enables extraCommonPackages";
    };
  };

  config = lib.mkIf config.extraCommonPackages.enable {
    home.packages = import ../../packages/extraCommon.nix pkgs;
  };

}
