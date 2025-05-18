{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    commonSystem = {
      enable = lib.mkEnableOption "enables commonSystem";
    };
  };
  
  config = lib.mkIf config.commonSystem.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

}
