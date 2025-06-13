{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    baseBrews = {
      enable = lib.mkEnableOption "enables baseBrews";
    };
  };
  
  config = lib.mkIf config.baseBrews.enable {
    homebrew = {
      enable = true;
      onActivation.cleanup = "uninstall";

      taps = [
      ];

      brews = [
        "autotrace"
      ];

      casks = [
        "amethyst"
        "bitwarden"
        "brave-browser"
        "cryptomator"
        "discord"
        "flux"
        "google-chrome"
        "google-drive"
        "hiddenbar"
        "iterm2"
        "karabiner-elements"
        "malwarebytes"
        "macfuse"
        "obsidian"
        "rocket"
        "scroll-reverser"
        "spotify"
        "sound-control"
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
