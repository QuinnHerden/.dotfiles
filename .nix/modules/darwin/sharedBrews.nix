{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    sharedBrews = {
      enable = lib.mkEnableOption "enables sharedBrews";
    };
  };
  
  config = lib.mkIf config.sharedBrews.enable {
    homebrew = {
      enable = true;
      onActivation.cleanup = "uninstall";

      taps = [
      ];

      brews = [
        #"autotrace"
      ];

      casks = [
        #"activitywatch"
        #"affinity-designer"
        #"affinity-photo"
        #"affinity-publisher"
        #"amethyst"
        #"anki"
        #"balenaetcher"
        #"betterdisplay"
        #"bitwarden"
        #"brave-browser"
        #"calibre"
        #"dbeaver-community"
        #"discord"
        #"docker" 
        #"flux"
        #"google-chrome"
        #"google-drive"
        #"hiddenbar"
        #"inkscape"
        #"iterm2"
        #"karabiner-elements"
        #"keycastr"
        #"loom"
        #"malwarebytes"
        #"obs"
        #"obsidian"
        #"postman"
        #"raspberry-pi-imager"
        #"rocket"
        #"scroll-reverser"
        #"spotify"
        #"vb-cable"
        #"visual-studio-code"
        #"vlc"
        #"yubico-yubikey-manager"
      ];

      masApps = {
        #"Keynote" = 409183694;
        #"Tailscale" = 1475387142;
      };

      whalebrews = [
      ];
    };
  };

}