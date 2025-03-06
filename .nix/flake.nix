{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # Environment / System management
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
        openssh.authorizedKeys.keyFiles = [
        ];
        
        packages = with pkgs; [
        ];
      };

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;
      
      # Enable sudo auth via touchID
      security.pam.services.sudo_local.touchIdAuth = true;

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
