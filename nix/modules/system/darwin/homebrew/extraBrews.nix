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
      ];

      casks = [
        "4k-stogram"
        "affinity-designer"
        "affinity-photo"
        "affinity-publisher"
        "anki"
        "balenaetcher"
        "calibre"
        "dbeaver-community"
        "keycastr"
        "obs"
        "protege"
        "raspberry-pi-imager"
        "vb-cable"
        "zotero"
      ];

      masApps = {
      };

      whalebrews = [
      ];
    };
  };

}
