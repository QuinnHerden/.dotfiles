{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    commonBaseHome = {
      enable = lib.mkEnableOption "enables common baseHome";

      name = lib.mkOption {
        default = "driver";
      };
    };
  };

  config = lib.mkIf config.commonBaseHome.enable {
    home-manager.users.${config.commonBaseHome.name} = {
      imports = [ ../content/base.nix ];
    };
  };

}
