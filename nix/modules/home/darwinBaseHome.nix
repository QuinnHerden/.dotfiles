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
    home-manager.users.${config.darwinBaseHome.name} = { config, pkgs, ... }: {
      home.file = {
        # ./
        "iterm2" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/iterm2";
          recursive = true;
        };
        ".config/karabiner" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/karabiner";
          recursive = true;
        };
      };

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "24.11";
    };
  };

}
