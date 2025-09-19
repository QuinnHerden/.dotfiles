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
      ];

      casks = [
        "amethyst"
        "bitwarden"
        "brave-browser"
        "flux-app"
        "hiddenbar"
        "iterm2"
        "karabiner-elements"
        "rocket"
        "scroll-reverser"
        "sound-control"
        "vlc"
      ];

      masApps = {
        "WireGuard" = 1451685025;
      };

      whalebrews = [
      ];
    };
  };

}
