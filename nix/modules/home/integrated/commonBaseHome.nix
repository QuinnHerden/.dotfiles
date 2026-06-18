{
  lib,
  config,
  ...
}:

{

  options = {
    commonBaseHome = {
      enable = lib.mkEnableOption "enables common baseHome";

      name = lib.mkOption {
        default = config.user.name;
      };
    };
  };

  config = lib.mkIf config.commonBaseHome.enable {
    home-manager.users.${config.commonBaseHome.name} = {
      imports = [ ../content/base.nix ];
    };
  };

}
