{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    opsCommonPackages = {
      enable = lib.mkEnableOption "enables opsCommonPackages";
    };
  };

  config = lib.mkIf config.opsCommonPackages.enable {
    home.packages = import ../../packages/opsCommon.nix pkgs;
  };

}
