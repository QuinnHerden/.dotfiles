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
    environment.systemPackages = import ../../../../packages/secCommon.nix pkgs;
  };

}
