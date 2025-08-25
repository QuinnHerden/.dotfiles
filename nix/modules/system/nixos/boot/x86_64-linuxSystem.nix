{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    x86_64-linuxSystem = {
      enable = lib.mkEnableOption "enables x86_64-linuxSystem";
    };
  };
  
  config = lib.mkIf config.x86_64-linuxSystem.enable {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

  };

}
