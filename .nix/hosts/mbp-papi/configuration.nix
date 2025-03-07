{
  pkgs,
  ...
}:

{
  imports = [
    ./main-user.nix
  ];

  main-user = {
    enable = true;
    userName = "quinnherden";
  };

  # Docs: https://daiderd.com/nix-darwin/manual/index.html

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

  # The platform the configuration will be used on.
  # If you're on an Intel system, replace with "x86_64-darwin"
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Set the configured group ID to match the actual value
  # Possible cause: trying a new Nix installation with a pre-existing installation
  ids.gids.nixbld = 350;

  # Enable sudo auth via touchID
  #security.pam.services.sudo_local.touchIdAuth = true;

  # Configure package installation
  nixpkgs.config = {
    allowUnfree = true; # allow paid licenses
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

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    taps = [
    ];

    brews = [
      "autotrace"
    ];

    casks = [
      "activitywatch"
      "affinity-designer"
      "affinity-photo"
      "affinity-publisher"
      "amethyst"
      "anki"
      "balenaetcher"
      "betterdisplay"
      "bitwarden"
      "brave-browser"
      "calibre"
      "dbeaver-community"
      "discord"
      "docker" 
      "flux"
      "google-chrome"
      "google-drive"
      "hiddenbar"
      "inkscape"
      "iterm2"
      "karabiner-elements"
      "keycastr"
      "loom"
      "malwarebytes"
      "obs"
      "obsidian"
      "postman"
      "raspberry-pi-imager"
      "rocket"
      "scroll-reverser"
      "spotify"
      "vb-cable"
      "visual-studio-code"
      "vlc"
      "yubico-yubikey-manager"
    ];

    masApps = {
      "Keynote" = 409183694;
      "Tailscale" = 1475387142;
    };

    whalebrews = [
    ];
  };

  fonts = {
    packages = [
      pkgs.nerd-fonts.fira-code
    ];
  };

  # Install and setup ZSH to work with nix(-darwin) as well
  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}