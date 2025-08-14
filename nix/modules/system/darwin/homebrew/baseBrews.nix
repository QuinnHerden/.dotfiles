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
        "flux-app"
        "google-chrome"
        "google-drive"
        "hiddenbar"
        "iterm2"
        "karabiner-elements"
        "macfuse"
        "malwarebytes"
        "obsidian"
        "protonvpn"
        "rocket"
        "scroll-reverser"
        "sound-control"
        "visual-studio-code"
        "vlc"
        "yubico-yubikey-manager"
      ];

      masApps = {
        "Keynote" = 409183694;
        "QuikFlow" = 1626354390;
        "Tailscale" = 1475387142;
      };

      whalebrews = [
      ];
    };
  };

}
