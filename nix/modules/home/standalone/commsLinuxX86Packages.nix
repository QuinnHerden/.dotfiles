{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    commsLinuxX86Packages = {
      enable = lib.mkEnableOption "enables commsLinuxX86Packages";
    };
  };

  config = lib.mkIf config.commsLinuxX86Packages.enable {
    home.packages = import ../../packages/commsLinuxX86.nix pkgs;
  };

}
