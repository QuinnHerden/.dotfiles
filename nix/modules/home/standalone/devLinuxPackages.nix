{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    devLinuxPackages = {
      enable = lib.mkEnableOption "enables devLinuxPackages";
    };
  };

  config = lib.mkIf config.devLinuxPackages.enable {
    home.packages = import ../../packages/devLinux.nix pkgs;
  };

}
