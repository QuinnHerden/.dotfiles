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
      ansible
      awscli2
      cmake
      duckdb
      eslint_d
      fd
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
      neofetch
      neovim
      nmap
      nodejs
      ollama
      openssl
      packer
      pandoc
      pipx
      podman
      postgresql
      postman
      potrace
      pre-commit
      prettierd
      python314
      ripgrep
      sshpass
      stylua
      terraform
      tflint
      tmux
      tree
      tree-sitter
      uv
      vim
      wget
      yarn
    ];
  };

}
