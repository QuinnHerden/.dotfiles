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
      bitwarden-cli
      bitwarden-desktop
      brave
      discord
      feh
      keyd
      obs-studio
      obsidian
      qutebrowser
      rofi
      spotify
    ];
  };

}
