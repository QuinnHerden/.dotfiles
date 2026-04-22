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
    home.packages = import ../../packages/secLinux.nix pkgs;
  };

}
