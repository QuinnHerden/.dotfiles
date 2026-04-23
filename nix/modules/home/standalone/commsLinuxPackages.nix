{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    commsLinuxPackages = {
      enable = lib.mkEnableOption "enables commsLinuxPackages";
    };
  };

  config = lib.mkIf config.commsLinuxPackages.enable {
    home.packages = import ../../packages/commsLinux.nix pkgs;
  };

}
