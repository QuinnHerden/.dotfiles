{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    sharedFonts = {
      enable = lib.mkEnableOption "enables sharedFonts";
    };
  };
  
  config = lib.mkIf config.sharedFonts.enable {
   fonts = {
      packages = with pkgs; [
        pkgs.nerd-fonts.fira-code
      ];
    }; 
  };
}