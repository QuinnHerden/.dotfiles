{
  common = pkgs: with pkgs; [
    bat
    curlie
    eslint_d
    eza
    fzf
    git
    gnugrep
    htop
    lazygit
    neofetch
    neovim
    openssl
    pipx
    postgresql
    posting
    pre-commit
    prettierd
    ripgrep
    thefuck
    tmux
    tree
    tree-sitter
    vim
    zoxide
  ];

  # Heavy tools not needed in lightweight/container environments
  heavy = pkgs: with pkgs; [
    ffmpeg
    httrack
    ollama
    openvpn
    pandoc
    potrace
  ];

  linux = pkgs: with pkgs; [
    xclip
  ];

  linuxX86 = pkgs: with pkgs; [
  ];

  linuxGui = pkgs: with pkgs; [
    alacritty
    bitwarden-cli
    bitwarden-desktop
    brave
    brightnessctl
    feh
    obsidian
    qutebrowser
    rofi
  ];

  darwin = {
    brews = [];
    casks = [
      "amethyst"
      "brave-browser"
      "flux-app"
      "hiddenbar"
      "iterm2"
      "karabiner-elements"
      "libreoffice"
      "malwarebytes"
      "obsidian"
      "protonvpn"
      "rocket"
      "scroll-reverser"
      "sound-control"
      "vlc"
      "yubico-yubikey-manager"
    ];
    masApps = {};
  };
}
