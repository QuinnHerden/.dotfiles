{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    darwinPackages = {
      enable = lib.mkEnableOption "enables darwinPackages";
    };
  };
  
  config = lib.mkIf config.darwinPackages.enable {
    environment.systemPackages = with pkgs; [
    ];
  };

}