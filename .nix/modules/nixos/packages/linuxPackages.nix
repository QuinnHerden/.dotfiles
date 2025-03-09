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
      activitywatch
      alacritty
      anki
      bitwarden-desktop
      discord
      dmenu
      feh
      i3lock
      i3status
      obs-studio
      obsidian
      picom
      rofi
      spotify
    ];
  };

}