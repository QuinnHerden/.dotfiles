{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    linuxPackages = {
      enable = lib.mkEnableOption "enables linuxPackages";
    };
  };
  
  config = lib.mkIf config.linuxPackages.enable {
    environment.systemPackages = with pkgs; [
      alacritty
      dmenu
      feh
      i3lock
      i3status
      picom
      rofi
    ];
  };

}