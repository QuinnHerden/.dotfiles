{
  lib,
  config,
  ...
}:

{

  options = {
    linuxBaseHome = {
      enable = lib.mkEnableOption "enables linux baseHome";

      name = lib.mkOption {
        default = config.user.name;
      };
    };
  };

  config = lib.mkIf config.linuxBaseHome.enable {
    home-manager.users.${config.linuxBaseHome.name} = {
      imports = [ ../content/linux.nix ];
    };
  };

}
