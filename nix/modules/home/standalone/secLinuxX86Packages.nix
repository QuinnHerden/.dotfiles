{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    secLinuxX86Packages = {
      enable = lib.mkEnableOption "enables secLinuxX86Packages";
    };
  };

  config = lib.mkIf config.secLinuxX86Packages.enable {
    home.packages = import ../../packages/secLinuxX86.nix pkgs;
  };

}
