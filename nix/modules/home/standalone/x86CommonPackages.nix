{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    standaloneX86CommonPackages = {
      enable = lib.mkEnableOption "enables standaloneX86CommonPackages";
    };
  };

  config = lib.mkIf config.standaloneX86CommonPackages.enable {
    home.packages = import ../../packages/x86Common.nix pkgs;
  };

}
