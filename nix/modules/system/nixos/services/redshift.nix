{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    redshift = {
      enable = lib.mkEnableOption "enables redshift";
    };
  };
  
  config = lib.mkIf config.redshift.enable {
    location.provider = "geoclue2";

    services.redshift = {
      enable = true;
      brightness = {
        day = "1";
        night = "1";
      };
      temperature = {
        day = 5500;
        night = 3700;
      };
    };

  };

}
