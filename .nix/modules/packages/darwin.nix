{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    darwin = {
      enable = lib.mkEnableOption "enables darwin";
    };
  };
  
  config = lib.mkIf config.darwin.enable {
    environment.systemPackages = with pkgs; [
    ];
  };

}