{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    commsCommonPackages = {
      enable = lib.mkEnableOption "enables commsCommonPackages";
    };
  };

  config = lib.mkIf config.commsCommonPackages.enable {
    home.packages = import ../../packages/commsCommon.nix pkgs;
  };

}
