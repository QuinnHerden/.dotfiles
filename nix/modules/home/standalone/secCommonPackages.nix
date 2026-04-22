{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    secCommonPackages = {
      enable = lib.mkEnableOption "enables secCommonPackages";
    };
  };

  config = lib.mkIf config.secCommonPackages.enable {
    home.packages = import ../../packages/secCommon.nix pkgs;
  };

}
