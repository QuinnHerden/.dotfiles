{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    keyd = {
      enable = lib.mkEnableOption "enables keyd";
    };
  };
 
  config = lib.mkIf config.keyd.enable {
    services.keyd = {
      enable = true;

      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              "capslock" = "overload(control, capslock)";

              "leftcontrol" = "layer(meta)";
              "meta" = "layer(alt)";
              "leftalt" = "layer(control)";

              "rightalt" = "layer(altgr)";
            };

            # default control layer
            "control" = {
              "[" = "esc";
            };

            # default right alt layer
            "altgr" = {
              "h" = "left";
              "j" = "down";
              "k" = "up";
              "l" = "right";
            };

          };
        };
      };
    };
  };

}
