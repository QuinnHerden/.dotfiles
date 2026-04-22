{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    linuxBaseHome = {
      enable = lib.mkEnableOption "enables linux baseHome";

      name = lib.mkOption {
        default = "driver";
      };
    };
  };

  config = lib.mkIf config.linuxBaseHome.enable {
    home-manager.users.${config.linuxBaseHome.name} = {
      imports = [ ../content/linux.nix ];
    };
  };

}
