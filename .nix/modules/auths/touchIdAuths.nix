{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    touchIdAuths = {
      enable = lib.mkEnableOption "enables touchIdAuths";
    };
  };
  
  config = lib.mkIf config.touchIdAuths.enable {
    # Enable sudo auth via touchID
    security.pam.services.sudo_local.touchIdAuth = true;
  };

}