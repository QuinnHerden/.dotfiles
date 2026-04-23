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
    environment.systemPackages = import ../../../packages/infraCommon.nix pkgs;
  };

}
