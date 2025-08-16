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
        # ./
        ".background-image".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.background-image";

        ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.gitconfig";
        ".gitignore_global".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.gitignore_global";
        
        ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.tmux.conf";

        "iterm2" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/iterm2";
          recursive = true;
        };

        # ./config
        ".config/i3" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/i3";
          recursive = true;
        };

        ".config/karabiner" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/karabiner";
          recursive = true;
        };

        ".config/nvim" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/nvim";
          recursive = true;
        };

        ".config/rofi" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/rofi";
          recursive = true;
        };
        ".config/qutebrowser/config.py".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/qutebrowser/config.py";
        
        # ./local
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
        };

        initExtra = ''
          eval "$(zoxide init --cmd cd zsh)"
          eval $(thefuck --alias f)
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
