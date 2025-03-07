{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    sharedPackages = {
      enable = lib.mkEnableOption "enables sharedPackages";
    };
  };
  
  config = lib.mkIf config.sharedPackages.enable {
    nixpkgs.config = {
      allowUnfree = true; # accept paid licenses
    };

    environment.systemPackages = with pkgs; [
      argocd
      awscli
      balena-cli
      bitwarden-cli
      brave
      cmake
      discord
      docker
      duckdb
      ffmpeg
      figlet
      fzf
      gawk
      gh
      gnugrep
      gnupg
      go
      google-chrome
      htop
      httrack
      inkscape
      hugo
      jq
      kubectx
      kubernetes-helm
      lazydocker
      lazygit
      markdownlint-cli
      neofetch
      neovim
      nmap
      nodejs_23
      ollama
      openssl
      pandoc
      pipx
      postgresql
      postman
      potrace
      pre-commit
      python310
      python311
      python312
      python313
      python314
      python39
      ripgrep
      spotify
      stow
      talosctl
      terraform
      tflint
      thefuck
      tmux
      tree
      tree-sitter
      typescript
      uv
      vault
      wget
      yt-dlp
      zoxide
    ];
  };

}