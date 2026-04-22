{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    nixosBaseHome = {
      enable = lib.mkEnableOption "enables nixos baseHome";

      name = lib.mkOption {
        default = "driver";
      };
    };
  };

  config = lib.mkIf config.nixosBaseHome.enable {
    home-manager.users.${config.nixosBaseHome.name} = {
      imports = [ ../content/linux.nix ];
    };
  };

}
