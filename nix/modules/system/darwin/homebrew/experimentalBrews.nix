{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    experimentalBrews = {
      enable = lib.mkEnableOption "enables experimentalBrews";
    };
  };
  
  config = lib.mkIf config.experimentalBrews.enable {
    homebrew = {
      enable = true;
      onActivation.cleanup = "uninstall";

      taps = [
      ];

      brews = [
      ];

      casks = [
        "powershell"
      ];

      masApps = {
      };

      whalebrews = [
      ];
    };
  };

}
