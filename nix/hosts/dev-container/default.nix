{
  lib,
  config,
  pkgs,
  ...
}:

{

  home.username = "dev";
  home.homeDirectory = "/home/dev";

  devPackages.enable = true;

  # Shell tools from ops.nix common list (base.nix aliases depend on these)
  # Excluding GUI/desktop packages and heavy tools (ollama, ffmpeg, etc.)
  home.packages = with pkgs; [
    bat
    eza
    fzf
    git
    gnugrep
    htop
    neovim
    ripgrep
    thefuck
    tmux
    tree
    tree-sitter
    vim
    zoxide
  ];

}
