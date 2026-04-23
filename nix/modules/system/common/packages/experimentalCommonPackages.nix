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
    environment.systemPackages = import ../../../packages/experimentalCommon.nix pkgs;
  };

}
