{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    hostname = {
      enable = lib.mkEnableOption "enables hostname";

      name = lib.mkOption {
        default = "mac";
      };
    };
  };
  
  config = lib.mkIf config.hostname.enable {
    system.defaults.smb = {
      NetBIOSName = "${config.hostname.name}";
      ServerDescription = "${config.hostname.name}";
    };
  };

}