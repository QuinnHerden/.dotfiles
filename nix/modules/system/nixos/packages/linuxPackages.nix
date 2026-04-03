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
      brightnessctl
      discord
      feh
      gcc
      gnumake
      obs-studio
      obsidian
      pipewire
      qutebrowser
      rofi
      signal-desktop
      tailscale
      unzip
      xclip
    ];
  };

}
