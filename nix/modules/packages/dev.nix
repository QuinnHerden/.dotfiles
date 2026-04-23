{
  common = pkgs: with pkgs; [
    cmake
    curlie
    duckdb
    eslint_d
    gh
    go
    lazydocker
    lazygit
    ngrok
    nodejs
    openssl
    pipx
    podman
    postgresql
    posting
    pre-commit
    prettierd
    python314
    stylua
    uv
  ];

  linux = pkgs: with pkgs; [
    gcc
    unzip
  ];

  linuxX86 = pkgs: with pkgs; [
  ];

  darwin = {
    brews = [];
    casks = [
      "dbeaver-community"
      "docker-desktop"
      "google-chrome"
      "postman"
    ];
    masApps = {};
  };
}
