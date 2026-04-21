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
        "watchman"
      ];

      casks = [
        "4k-stogram"
        "affinity-designer"
        "affinity-photo"
        "affinity-publisher"
        "anki"
        "balenaetcher"
        "calibre"
        "claude-code"
        "dbeaver-community"
        "discord"
        "docker-desktop"
        "fathom"
        "google-chrome"
        "google-drive"
        "libreoffice"
        "loom"
        "malwarebytes"
        "obs"
        "obsidian"
        "postman"
        "protonvpn"
        "raspberry-pi-imager"
        "signal"
        "vb-cable"
        "virtualbox"
        "visual-studio-code"
        "whatsapp"
        "yubico-yubikey-manager"
        "zotero"
        "zulu@17"
      ];

      masApps = {
        "Keynote" = 409183694;
        "Readest - eBook Reader" = 6738622779;
      };

      whalebrews = [
      ];
    };
  };

}
