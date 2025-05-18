{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    openssh = {
      enable = lib.mkEnableOption "enables openssh";
    };
  };
  
  config = lib.mkIf config.openssh.enable {
    services.openssh = {
      enable = true;
      
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
      };
    };
  };

}