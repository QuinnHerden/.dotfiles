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
      bitwarden-desktop
      brave
      discord
      dmenu
      feh
      i3lock
      i3status
      keyd
      obs-studio
      obsidian
      picom
      rofi
      spotify
    ];
  };

}
