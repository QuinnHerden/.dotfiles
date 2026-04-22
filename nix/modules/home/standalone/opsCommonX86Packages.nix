{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    opsCommonX86Packages = {
      enable = lib.mkEnableOption "enables opsCommonX86Packages";
    };
  };

  config = lib.mkIf config.opsCommonX86Packages.enable {
    home.packages = import ../../packages/opsCommonX86.nix pkgs;
  };

}
