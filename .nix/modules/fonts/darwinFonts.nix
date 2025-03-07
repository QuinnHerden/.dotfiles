{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    darwinFonts = {
      enable = lib.mkEnableOption "enables darwinFonts";
    };
  };
  
  config = lib.mkIf config.darwinFonts.enable {
    fonts = {
      packages = [
        pkgs.nerd-fonts.fira-code
      ];
    };
  };

}