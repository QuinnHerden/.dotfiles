{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    experimentalFeatures = {
      enable = lib.mkEnableOption "enables experimentalFeatures";
    };
  };
  
  config = lib.mkIf config.experimentalFeatures.enable {
    nix.settings.experimental-features = [
      "flakes"
      "nix-command"
    ];

  };
}
