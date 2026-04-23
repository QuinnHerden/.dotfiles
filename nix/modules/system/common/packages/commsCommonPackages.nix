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
    environment.systemPackages = import ../../../packages/commsCommon.nix pkgs;
  };

}
