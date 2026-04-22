{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    linuxPackages = {
      enable = lib.mkEnableOption "enables linuxPackages";
    };
  };

  config = lib.mkIf config.linuxPackages.enable {
    environment.systemPackages = import ../../../../packages/linux.nix pkgs;
  };

}
