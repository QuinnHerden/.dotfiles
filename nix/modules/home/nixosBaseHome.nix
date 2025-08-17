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
    home-manager.users.${config.nixosBaseHome.name} = { config, pkgs, ... }: {
      home.file = {
        # ./
        ".background-image".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.background-image";

        # ./config
        ".config/i3" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/i3";
          recursive = true;
        };

        ".config/rofi" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/rofi";
          recursive = true;
        };
        ".config/qutebrowser/config.py".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/qutebrowser/config.py";
      };

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "24.11";
    };
  };

}
