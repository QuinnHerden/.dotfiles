{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    devLinuxX86Packages = {
      enable = lib.mkEnableOption "enables devLinuxX86Packages";
    };
  };

  config = lib.mkIf config.devLinuxX86Packages.enable {
    home.packages = import ../../packages/devLinuxX86.nix pkgs;
  };

}
