{
  lib,
  config,
  pkgs,
  ...
}:

{

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

}
