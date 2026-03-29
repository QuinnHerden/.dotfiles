
{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    pam = {
      enable = lib.mkEnableOption "enables pam";
    };
  };
  
  config = lib.mkIf config.pam.enable {
    security.pam = {
      u2f = {
        enable = true;
        control = "sufficient";
        settings = {
          pinverification = 1;
        };
      };

      # Enable Yubikey
      services = {
        # login
        login.u2fAuth = true;

        display-manager = { 
          enable = true;
          # login splash screen
          text = ''
            auth include system-login
            account include system-login
            password include system-login
            session include system-login
          '';
        };

        # priv escalation
        su.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };
  };

}
