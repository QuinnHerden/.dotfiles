{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    linux = {
      enable = lib.mkEnableOption "enables linux";
    };
  };
  
  config = lib.mkIf config.linux.enable {
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