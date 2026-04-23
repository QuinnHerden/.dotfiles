{
  lib,
  config,
  pkgs,
  ...
}:

{

  home.file = {
    # ./
    ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.gitconfig";
    ".gitignore_global".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.gitignore_global";

    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.tmux.conf";

    # ./claude
    ".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/settings.json";
    ".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/CLAUDE.md";
    ".claude/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/keybindings.json";
    ".claude/commands".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/commands";
    ".claude/agents".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/agents";
    ".claude/skills".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/skills";
    ".claude/rules".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/rules";
    ".claude/output-styles".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/output-styles";
    ".claude/hooks".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/hooks";

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
      # cat
      cat = "bat";

      # curl
      curl = "curlie";

      # env
      e = "set -a; source .env; set +a;";

      # eza
      ls = "eza $eza_params";
      l = "eza --git-ignore $eza_params";
      ll = "eza --all --header --long $eza_params";
      llm = "eza --all --header --long --sort=modified $eza_params";
      la = "eza -lbhHigUmuSa";
      lx = "eza -lbhHigUmuSa@";
      lt = "eza --tree $eza_params";
      tree = "eza --tree $eza_params";

      # fzf
      ff = "fzf --style full --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'";

      # git
      gs = "git status";
      gd = "git diff";
      ga = "git add";
      gc = "git commit -m";
      gp = "git push";

      # grep
      grep = "rg";

      # kubectl
      k = "kubectl";

      # python
      python = "python3";
      pip = "pip3";

      # ssh
      rmkh = "rm ~/.ssh/known_hosts";

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
      export PATH="$HOME/.nix-profile/bin:$PATH"
      eza_params=()
      eval "$(fzf --zsh)"
      eval "$(zoxide init --cmd cd zsh)"
      eval $(thefuck --alias f)
    '';
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.11";

}
