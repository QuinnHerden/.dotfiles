{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = {pkgs, ... }: {
      # Docs: https://daiderd.com/nix-darwin/manual/index.htm

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility. please read the changelog
      # before changing: `darwin-rebuild changelog`.
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      # If you're on an Intel system, replace with "x86_64-darwin"
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Set the configured group ID to match the actual value
      # Possible cause: trying a new Nix installation with a pre-existing installation
      ids.gids.nixbld = 350;

      # Declare the user that will be running `nix-darwin`.
      users.users.quinnherden = {
        name = "quinnherden";
        home = "/Users/quinnherden";
      };

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      environment.systemPackages = [
        pkgs.neofetch
      ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";

        taps = [
          "hashicorp/tap"
          "siderolabs/tap"
        ];

        brews = [
          "ansible"
          "argocd"
          "autotrace"
          "awk"
          "awscli"
          "cmake"
          "duckdb"
          "ffmpeg"
          "figlet"
          "fzf"
          "gh"
          "gnupg"
          "go"
          "grep"
          "helm"
          "htop"
          "httrack"
          "hugo"
          "jq"
          "jupyterlab"
          "kubectx"
          "lazydocker"
          "lazygit"
          "lua"
          "markdownlint-cli"
          "mas"
          "neovim"
          "nmap"
          "node"
          "ollama"
          "openssl@3"
          "packer"
          "pandoc"
          "pipx"
          "postgresql"
          "potrace"
          "pre-commit"
          "python@3.10"
          "python@3.13"
          "ripgrep"
          "rust"
          "stow"
          "syncthing"
          "talosctl"
          "tesseract"
          "terraform"
          "tesseract"
          "tflint"
          "thefuck"
          "tmux"
          "tree"
          "tree-sitter"
          "typescript"
          "unbound"
          "uv"
          "vault"
          "wget"
          "wireguard-tools"
          "yt-dlp"
          "zoxide"
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
          "rocket"
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
    };
  in
  {
    darwinConfigurations."mbp-papi" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
      ];
    };
  };
}
