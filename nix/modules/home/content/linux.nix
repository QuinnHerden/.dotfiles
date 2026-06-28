{
  config,
  ...
}:

{

  home.file = {
    # ./
    ".background-image".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.background-image";

    # ./config — single out-of-store symlinks into the live (read/write) repo.
    # No `recursive = true`: combined with mkOutOfStoreSymlink it clobbers the
    # repo (see #206). i3/rofi don't rewrite their config at runtime, so nothing
    # extra lands in-tree.
    ".config/i3".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/i3";

    ".config/rofi".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/rofi";

    ".config/qutebrowser/config.py".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/qutebrowser/config.py";
  };

}
