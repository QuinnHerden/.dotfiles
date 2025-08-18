{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    wifi = {
      enable = lib.mkEnableOption "enables wifi";
    };
  };
  
  config = lib.mkIf config.wifi.enable {
    networking.networkmanager.enable = true;
  };

}
