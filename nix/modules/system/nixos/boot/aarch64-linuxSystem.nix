{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    aarch64-linuxSystem = {
      enable = lib.mkEnableOption "enables aarch64-linuxSystem";
    };
  };
  
  config = lib.mkIf config.aarch64-linuxSystem.enable {
    boot.loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

  };

}
