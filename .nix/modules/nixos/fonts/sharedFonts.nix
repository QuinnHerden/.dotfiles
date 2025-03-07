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