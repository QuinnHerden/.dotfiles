{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    commonPackages = {
      enable = lib.mkEnableOption "enables commonPackages";
    };
  };
  
  config = lib.mkIf config.commonPackages.enable {
    nixpkgs.config = {
      allowUnfree = true; # accept paid licenses
    };

    programs.zsh.enable = true; # install zsh shell

    environment.systemPackages = with pkgs; [
      awscli
      cmake
      duckdb
      ffmpeg
      gawk
      gh
      git
      gnugrep
      gnupg
      go
      htop
      httrack
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
      podman
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
      terraform
      tflint
      tmux
      tree
      tree-sitter
      typescript
      uv
      vault
      vim
      wget
      yarn
    ];
  };

}
