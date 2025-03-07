{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    fonts = {
      enable = lib.mkEnableOption "enables fonts";
    };
  };
  
  config = lib.mkIf config.fonts.enable {
   fonts = {
      packages = [
        pkgs.nerd-fonts.fira-code
      ];
    }; 
  };
}