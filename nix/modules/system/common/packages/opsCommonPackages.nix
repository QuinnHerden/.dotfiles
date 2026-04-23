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
    environment.systemPackages = import ../../../packages/opsCommon.nix pkgs;
  };

}
