{
  lib,
  config,
  pkgs,
  ...
}:

{

  options = {
    commonBaseHome = {
      enable = lib.mkEnableOption "enables common baseHome";

      name = lib.mkOption {
        default = "driver";
      };
    };
  };
  
  config = lib.mkIf config.commonBaseHome.enable {
    home-manager.users.${config.commonBaseHome.name} = { config, pkgs, ... }: {
      home.file = {
        # ./
        ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.gitconfig";
        ".gitignore_global".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.gitignore_global";
        
        ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.tmux.conf";

        # ./config
        ".config/nvim" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/nvim";
          recursive = true;
        };

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
          ga = "git add";
          gc = "git commit -m";
          gp = "git push";

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
          tmss = "tmux switch-client -t";
          tmrs = "tmux rename-session -t";
          tmks = "tmux kill-session -t";

          # uv
          uvr = "uv run";
          uva = "uv add";
          uvad = "uv add --dev";

          # vim
          vi = "nvim";
        };

        initContent = ''
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
