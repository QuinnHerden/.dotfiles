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
      # Docs: https://daiderd.com/nix-darwin/manual/index.html

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

      # Configure package installation
      nixpkgs.config = {
        allowUnfree = true; # allow paid licenses
      };

      environment.systemPackages = [
        pkgs.argocd
        pkgs.awscli
        pkgs.cmake
        pkgs.duckdb
        pkgs.ffmpeg
        pkgs.figlet
        pkgs.fzf
        pkgs.gawk
        pkgs.gh
        pkgs.gnugrep
        pkgs.gnupg
        pkgs.go
        pkgs.htop
        pkgs.httrack
        pkgs.hugo
        pkgs.jq
        pkgs.kubectx
        pkgs.kubernetes-helm
        pkgs.lazydocker
        pkgs.lazygit
        pkgs.markdownlint-cli
        pkgs.neofetch
        pkgs.neovim
        pkgs.nmap
        pkgs.nodejs_23
        pkgs.ollama
        pkgs.openssl
        pkgs.pandoc
        pkgs.pipx
        pkgs.postgresql
        pkgs.potrace
        pkgs.pre-commit
        pkgs.python310
        pkgs.python311
        pkgs.python312
        pkgs.python313
        pkgs.python314
        pkgs.python39
        pkgs.ripgrep
        pkgs.stow
        pkgs.talosctl
        pkgs.terraform
        pkgs.tflint
        pkgs.thefuck
        pkgs.tmux
        pkgs.tree
        pkgs.tree-sitter
        pkgs.typescript
        pkgs.uv
        pkgs.vault
        pkgs.wget
        pkgs.yt-dlp
        pkgs.zoxide
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
