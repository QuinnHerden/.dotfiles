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
        "4k-storgram"
        "activitywatch"
        "affinity-designer"
        "affinity-photo"
        "affinity-publisher"
        "anki"
        "balenaetcher"
        "calibre"
        "dbeaver-community"
        "keycastr"
        "obs"
        "raspberry-pi-imager"
        "vb-cable"
      ];

      casks = [
      ];

      masApps = {
      };

      whalebrews = [
      ];
    };
  };

}
