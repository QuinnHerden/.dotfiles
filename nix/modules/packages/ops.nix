{
  common = pkgs: with pkgs; [
    bat
    curlie
    eslint_d
    eza
    ffmpeg
    fzf
    git
    gnugrep
    htop
    httrack
    lazygit
    neofetch
    neovim
    ollama
    openssl
    openvpn
    pandoc
    pipx
    postgresql
    posting
    potrace
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

  linux = pkgs: with pkgs; [
    alacritty
    bitwarden-cli
    bitwarden-desktop
    brave
    brightnessctl
    feh
    obsidian
    qutebrowser
    rofi
    xclip
  ];

  linuxX86 = pkgs: with pkgs; [
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
