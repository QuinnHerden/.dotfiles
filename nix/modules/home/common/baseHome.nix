{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    baseHome = {
      enable = lib.mkEnableOption "enables baseHome";

      name = lib.mkOption {
        default = "driver";
      };
    };
  };
  
  config = lib.mkIf config.baseHome.enable {
    home-manager.users.${config.baseHome.name} = { config, pkgs, ... }: {
      home.file = {
        ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/.gitconfig";
        ".gitignore_global".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/.gitignore_global";
        ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/.tmux.conf";
        ".config/nvim" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/nvim";
          recursive = true;
        };
        ".local/scripts" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/scripts";
          recursive = true;
        };
      };

      home.sessionPath = [
        "$HOME/.local/bin/"
        "$HOME/.local/scripts"
      ];

      programs.zsh = {
        enable = true;

        autosuggestion.enable = true;
        
        oh-my-zsh = {
          enable = true;
          theme = "nicoulaj";

          plugins = [
          ];

          extraConfig = ''
            zstyle ':omz:update' mode auto
          '';
        };

        sessionVariables = {
          EDITOR = "nvim";
        };

        shellAliases = {
          # git
          gs = "git status";
          gd = "git diff";

          # kubectl
          k = "kubectl";

          # python
          python = "python3";
          pip = "pip3";

          # tailscale
          ts = "tailscale";
          tssc = "ts switch sculpted.io; tailscale set --accept-routes=true;";
          tshr = "ts switch herden.io; tailscale set --accept-routes=true;";

          # terraform
          tf = "terraform";
          
          # thefuck
          fuck = "f";

          # tmux
          tmns = "tmux new -s";
          tmls = "tmux list-session";
          tmas = "tmux attach-session -t";
          tmrs = "tmux rename-session -t";
          tmks = "tmux kill-session -t";

          # vim
          vim = "nvim";
          vi = "vim";
        };

        initExtra = ''
          eval "$(zoxide init --cmd cd zsh)"
          eval $(thefuck --alias f)

          figlet -d ~/figlet-fonts -f "sub-zero" QSH
        '';
      };
      
      programs.thefuck = {
        enable = true;
        enableZshIntegration = true;
      };
      
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "24.11";
    };
  };

}
