{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    standaloneX86LinuxPackages = {
      enable = lib.mkEnableOption "enables standaloneX86LinuxPackages";
    };
  };

  config = lib.mkIf config.standaloneX86LinuxPackages.enable {
    home.packages = import ../../packages/x86Linux.nix pkgs;
  };

}
