{ config, pkgs, system, ... }:
  
let
  commonPackages = with pkgs [
    # Common packages for both macOS and NixOS

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

  nixosPackages = if system == "x86_64-linux" then with pkgs [
    # Packages exclusive to NixOS

    alacritty
    dmenu
    feh
    i3lock
    i3status
    picom
    rofi

  ] else [];

  macosPackages = if system == "aarch64-darwin" then with pkgs [
    # macOS-specific packages

  ] else [];

in

commonPackages ++ nixosPackages ++ macosPackages

builtins.trace "System is: ${system}" []
