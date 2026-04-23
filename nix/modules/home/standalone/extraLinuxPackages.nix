{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    extraLinuxPackages = {
      enable = lib.mkEnableOption "enables extraLinuxPackages";
    };
  };

  config = lib.mkIf config.extraLinuxPackages.enable {
    home.packages = import ../../packages/extraLinux.nix pkgs;
  };

}
