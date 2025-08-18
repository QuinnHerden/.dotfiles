{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    i3 = {
      enable = lib.mkEnableOption "enables i3";
    };
  };
  
  config = lib.mkIf config.i3.enable {
    services.xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      windowManager = {
        i3 = {
          enable = true;

          extraSessionCommands = ''
            xrandr --output DP-1 --rotate right --left-of eDP-1;
          '';
        };
      };
    };

    services.displayManager = {
      defaultSession = "none+i3";
    };
  };

}
