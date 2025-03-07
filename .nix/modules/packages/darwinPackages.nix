{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    darwinPackages = {
      enable = lib.mkEnableOption "enables darwinPackages";
    };
  };
  
  config = lib.mkIf config.darwinPackages.enable {
    programs.zsh.enable = true;

    environment.systemPackages = with pkgs; [
    ];

    homebrew = {
      enable = true;
      onActivation.cleanup = "uninstall";

      taps = [
      ];

      brews = [
        "autotrace"
      ];

      casks = [
        "activitywatch"
        "affinity-designer"
        "affinity-photo"
        "affinity-publisher"
        "amethyst"
        "anki"
        "balenaetcher"
        "betterdisplay"
        "bitwarden"
        "brave-browser"
        "calibre"
        "dbeaver-community"
        "discord"
        "docker" 
        "flux"
        "google-chrome"
        "google-drive"
        "hiddenbar"
        "inkscape"
        "iterm2"
        "karabiner-elements"
        "keycastr"
        "loom"
        "malwarebytes"
        "obs"
        "obsidian"
        "postman"
        "raspberry-pi-imager"
        "rocket"
        "scroll-reverser"
        "spotify"
        "vb-cable"
        "visual-studio-code"
        "vlc"
        "yubico-yubikey-manager"
      ];

      masApps = {
        "Keynote" = 409183694;
        "Tailscale" = 1475387142;
      };

      whalebrews = [
      ];
    };
  };

}