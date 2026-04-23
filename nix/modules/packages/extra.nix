{
  common = pkgs: with pkgs; [
    duckdb
    gnupg
    lazydocker
    netclient
    ngrok
    podman
    go
    jq
    nodejs
    pipx
    python314
    stylua
    uv
    wget
    yarn
    bat
    curlie
    eslint_d
    eza
    ffmpeg
    fzf
    gawk
    gh
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
    feh
  ];

  linuxX86 = pkgs: with pkgs; [
  ];

  darwin = {
    brews = [
      "autotrace"
    ];
    casks = [
      "4k-stogram"
      "affinity-designer"
      "affinity-photo"
      "affinity-publisher"
      "anki"
      "bitwarden"
      "claude-code"
      "google-drive"
      "zotero"
    ];
    masApps = {
      "Keynote" = 409183694;
      "Readest - eBook Reader" = 6738622779;
    };
  };
}
