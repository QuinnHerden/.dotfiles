{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    infraLinuxPackages = {
      enable = lib.mkEnableOption "enables infraLinuxPackages";
    };
  };

  config = lib.mkIf config.infraLinuxPackages.enable {
    home.packages = import ../../packages/infraLinux.nix pkgs;
  };

}
