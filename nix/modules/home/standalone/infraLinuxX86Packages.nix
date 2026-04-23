{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    infraLinuxX86Packages = {
      enable = lib.mkEnableOption "enables infraLinuxX86Packages";
    };
  };

  config = lib.mkIf config.infraLinuxX86Packages.enable {
    home.packages = import ../../packages/infraLinuxX86.nix pkgs;
  };

}
