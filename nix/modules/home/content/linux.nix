{
  config,
  ...
}:

{

  home.file = {
    # ./
    ".background-image".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.background-image";

    # ./config
    # NOTE: `mkOutOfStoreSymlink` + `recursive = true` is the clobber footgun
    # from #206. It is intentionally NOT removed here (unlike base.nix): i3/rofi
    # dirs may be written at runtime, so these likely need the in-store-source
    # remediation instead. Do not "simplify" to a bare out-of-store symlink
    # without resolving #206 for these mappings.
    ".config/i3" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/i3";
      recursive = true;
    };

    ".config/rofi" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/rofi";
      recursive = true;
    };

    ".config/qutebrowser/config.py".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/qutebrowser/config.py";
  };

}
