{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    darwinBaseHome = {
      enable = lib.mkEnableOption "enables darwin baseHome";

      name = lib.mkOption {
        default = "driver";
      };
    };
  };

  config = lib.mkIf config.darwinBaseHome.enable {
    home-manager.users.${config.darwinBaseHome.name} = {
      imports = [ ../content/darwin.nix ];
    };
  };

}
