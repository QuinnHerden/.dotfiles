{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    shared = {
      enable = lib.mkEnableOption "enables shared";
    };
  };
  
  config = lib.mkIf config.shared.enable {
    nixpkgs.config = {
      allowUnfree = true; # accept paid licenses
    };

    environment.systemPackages = with pkgs; [
      argocd
      awscli
      cmake
      duckdb
      ffmpeg
      figlet
      fzf
      gawk
      gh
      gnugrep
      gnupg
      go
      htop
      httrack
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
      potrace
      pre-commit
      python310
      python311
      python312
      python313
      python314
      python39
      ripgrep
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