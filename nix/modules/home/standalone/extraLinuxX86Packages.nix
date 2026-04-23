{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    extraLinuxX86Packages = {
      enable = lib.mkEnableOption "enables extraLinuxX86Packages";
    };
  };

  config = lib.mkIf config.extraLinuxX86Packages.enable {
    home.packages = import ../../packages/extraLinuxX86.nix pkgs;
  };

}
