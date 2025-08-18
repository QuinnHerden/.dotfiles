{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    libinput = {
      enable = lib.mkEnableOption "enables libinput";
    };
  };
  
  config = lib.mkIf config.libinput.enable {
    services.libinput = {
      enable = true;

      touchpad = {
        accelSpeed = "0.5";

        naturalScrolling = true;
        scrollMethod = "twofinger";

        tapping = true; # tap to click
      };

      mouse = {
        accelSpeed = "0.5";

        naturalScrolling = false;
      };
    };
  };

}
