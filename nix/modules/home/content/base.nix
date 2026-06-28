{
  lib,
  config,
  ...
}:

{

  home.file = {
    # ./
    ".gitconfig".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.gitconfig";
    ".gitignore_global".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.gitignore_global";

    ".tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.tmux.conf";

    # ./claude
    # On the laptop these manage ~/.claude directly. In dev containers Claude is
    # pointed at CLAUDE_CONFIG_DIR instead (see container/entrypoint.sh), which
    # symlinks these same dotfiles sources into the persistent per-container
    # config dir; the ~/.claude entries below are inert there. Keep both in sync.
    ".claude/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/settings.json";
    ".claude/statusline-command.sh".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/statusline-command.sh";
    ".claude/CLAUDE.md".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/CLAUDE.md";
    ".claude/keybindings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/keybindings.json";
    ".claude/commands".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/commands";
    ".claude/agents".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/agents";
    ".claude/skills".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/skills";
    # .claude/knowledge is handled by the activation script below, not here: its
    # source is the private/knowledge submodule, which a fork cannot clone, so an
    # unconditional symlink would dangle (#177).
    ".claude/rules".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/rules";
    ".claude/output-styles".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/output-styles";
    ".claude/hooks".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/home/.claude/hooks";

    # ./config
    # A single out-of-store symlink to the live repo dir. Do NOT add
    # `recursive = true`: combined with mkOutOfStoreSymlink it makes activation
    # write per-file symlinks back through the symlink into the repo, clobbering
    # tracked files (and, with `-b backup`, littering *.backup). See #206.
    # nvim writes lazy-lock.json into this dir at runtime (in-tree, gitignored).
    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/config/nvim";

    # ./local — same rule as .config/nvim above: no `recursive = true`. See #206.
    ".local/scripts".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/files/scripts";
  };

  # Link the private Claude knowledge library only when it is actually checked
  # out. The source (private/knowledge) is a submodule a fork cannot clone, and
  # it is an out-of-store path pure eval cannot stat, so the presence check has
  # to run at activation: link when present, drop a stale link when absent (so a
  # fork never gets a dangling ~/.claude/knowledge). #177. Honors
  # $DRY_RUN_CMD/$VERBOSE_ARG so `home-manager switch --dry-run` stays read-only.
  # A real directory at the target is left untouched in both branches, so a
  # stale dir is never clobbered into a nested link nor deleted. Dev containers
  # serve knowledge differently and are not handled here (see #181).
  home.activation.claudeKnowledge = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    src="${config.home.homeDirectory}/.dotfiles/private/knowledge"
    dst="${config.home.homeDirectory}/.claude/knowledge"
    if [ -d "$dst" ] && [ ! -L "$dst" ]; then
      echo "claude knowledge: $dst is a real directory, leaving it untouched" >&2
    elif [ -e "$src" ]; then
      $DRY_RUN_CMD ln -sfn $VERBOSE_ARG "$src" "$dst"
    elif [ -L "$dst" ] || [ ! -e "$dst" ]; then
      $DRY_RUN_CMD rm -f $VERBOSE_ARG "$dst"
    fi
  '';

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

      # opentofu
      tf = "tofu";

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

      # claude
      dangerclaude = "claude --dangerously-skip-permissions";

      # vim
      vi = "nvim";
    };

    # lib.mkAfter (priority 1500) ensures this entire block runs after any other
    # module that sets initContent at the default priority (1000). Zoxide must be
    # last or it emits a "possible configuration issue" warning.
    initContent = lib.mkAfter ''
      export PATH="$HOME/.nix-profile/bin:$PATH"
      eza_params=()
      eval "$(fzf --zsh)"
      eval $(thefuck --alias f)

      # Set DOCKER_HOST for podman on macOS (lazydocker, docker CLI compat)
      if command -v podman >/dev/null 2>&1 && [ "$(uname)" = "Darwin" ]; then
        export DOCKER_HOST="unix://$(podman machine inspect --format '{{.ConnectionInfo.PodmanSocket.Path}}' 2>/dev/null)"
      fi

      [[ -o interactive ]] && eval "$(zoxide init --cmd cd zsh)"
    '';
  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "24.11";

}
