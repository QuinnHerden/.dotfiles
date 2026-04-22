{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    opsLinuxPackages = {
      enable = lib.mkEnableOption "enables opsLinuxPackages";
    };
  };

  config = lib.mkIf config.opsLinuxPackages.enable {
    home.packages = import ../../packages/opsLinux.nix pkgs;
  };

}
