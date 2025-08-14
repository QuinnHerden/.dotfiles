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
        "protege"
      ];

      masApps = {
        "QuikFlow" = 1626354390;
      };

      whalebrews = [
      ];
    };
  };

}
