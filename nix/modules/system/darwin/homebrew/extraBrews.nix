{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    extraBrews = {
      enable = lib.mkEnableOption "enables extraBrews";
    };
  };
  
  config = lib.mkIf config.extraBrews.enable {
    homebrew = {
      enable = true;
      onActivation.cleanup = "uninstall";

      taps = [
      ];

      brews = [
        "autotrace"
      ];

      casks = [
        "4k-stogram"
        "affinity-designer"
        "affinity-photo"
        "affinity-publisher"
        "anki"
        "balenaetcher"
        "calibre"
        "cryptomator"
        "dbeaver-community"
        "discord"
        "google-chrome"
        "google-drive"
        "macfuse"
        "malwarebytes"
        "obs"
        "obsidian"
        "protonvpn"
        "raspberry-pi-imager"
        "signal"
        "vb-cable"
        "visual-studio-code"
        "whatsapp"
        "yubico-yubikey-manager"
        "zotero"
      ];

      masApps = {
        "Keynote" = 409183694;
      };

      whalebrews = [
      ];
    };
  };

}
