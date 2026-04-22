{
  lib,
  config,
  pkgs,
  ...
}:

{

  home.file = {
    # ./
    "iterm2" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/iterm2";
      recursive = true;
    };

    # ./config
    ".config/karabiner" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/karabiner";
      recursive = true;
    };
  };

}
