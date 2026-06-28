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
    # ./ — single out-of-store symlinks into the live (read/write) repo. No
    # `recursive = true`: combined with mkOutOfStoreSymlink it clobbers the repo
    # (see #206). The iterm2 dir is a passive profile stash imported by hand;
    # nothing writes to it at runtime.
    "iterm2".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/iterm2";

    # ./config — Karabiner rewrites karabiner.json in place, so its edits now
    # land in the repo working tree (intended — they become tracked diffs); its
    # automatic_backups/ is already gitignored.
    ".config/karabiner".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/karabiner";
  };

}
