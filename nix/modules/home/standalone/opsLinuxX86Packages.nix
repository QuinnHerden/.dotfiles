{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    opsLinuxX86Packages = {
      enable = lib.mkEnableOption "enables opsLinuxX86Packages";
    };
  };

  config = lib.mkIf config.opsLinuxX86Packages.enable {
    home.packages = import ../../packages/opsLinuxX86.nix pkgs;
  };

}
