{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    commonFonts = {
      enable = lib.mkEnableOption "enables commonFonts";
    };
  };
  
  config = lib.mkIf config.commonFonts.enable {
   fonts = {
      packages = with pkgs; [
        dina-font
        fira-code
        fira-code-symbols
        liberation_ttf
        mplus-outline-fonts.githubRelease
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        proggyfonts
      ];
    }; 
  };
}