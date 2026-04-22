{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    standaloneLinuxPackages = {
      enable = lib.mkEnableOption "enables standaloneLinuxPackages";
    };
  };

  config = lib.mkIf config.standaloneLinuxPackages.enable {
    home.packages = import ../../packages/linux.nix pkgs;
  };

}
