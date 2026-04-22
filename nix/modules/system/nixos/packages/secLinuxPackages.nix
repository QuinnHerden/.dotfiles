{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    secLinuxPackages = {
      enable = lib.mkEnableOption "enables secLinuxPackages";
    };
  };

  config = lib.mkIf config.secLinuxPackages.enable {
    environment.systemPackages = import ../../../../packages/secLinux.nix pkgs;
  };

}
