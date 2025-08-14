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

    services.xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };
    
      displayManager = {
          defaultSession = "none+i3";
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu #application launcher most people use
          i3status # gives you the default i3 status bar
          i3blocks #if you are planning on using i3blocks over i3status
      ];
      };
    };
    
    programs.i3lock.enable = true; #default i3 screen locker
  };

}
