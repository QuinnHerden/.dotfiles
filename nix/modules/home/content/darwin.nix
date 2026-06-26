{
  config,
  ...
}:

{

  home.sessionPath = [
    "$ANDROID_HOME/emulator"
    "$ANDROID_HOME/platform-tools"
  ];

  home.sessionVariables = {
    JAVA_HOME = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home";
    ANDROID_HOME = "$HOME/Library/Android/sdk";
  };

  home.file = {
    # ./
    # NOTE: `mkOutOfStoreSymlink` + `recursive = true` is the clobber footgun
    # from #206. It is intentionally NOT removed here (unlike base.nix): iTerm2
    # and Karabiner rewrite these dirs at runtime, so they likely need the
    # in-store-source remediation instead. Do not "simplify" to a bare
    # out-of-store symlink without resolving #206 for these mappings.
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
