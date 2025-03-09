{
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.home-manager.darwinModules.default
  ];

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
  system.stateVersion = 4; # $ darwin-rebuild changelog
  
  nixpkgs.hostPlatform = "aarch64-darwin";

  darwinPackages.enable = true;
  baseBrews.enable = true;
  extraBrews.enable = true;
  experimentalBrews.enable = true;
  
  hostname = {
    enable = true;
    name = "mac-papi";
  };

  #driverUser = {
    #enable = true;
    #userName = "quinnherden";
  #};
  users.users.quinnherden = {
    name = "quinnherden";
    home = "/Users/quinnherden";

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2aUAuv3nXZ2xUyydp6QA0zovy7L7iRlSC1ilxm37/tuva7kyJnMZPGmbpOM2vyp3fHOZpW0HV5nD72Q+4ofXHL8gTXhU0vqh2hIzyhFnwn6J/bsmrYu+3EEjzDR0GQFwlXTyBuX84paXHv5PN08/MTAgkdvt63VB0xsBMnQSqbHOpXzkm0Kja+aHGGEUdEXa5DrbcVc4pM+T9OutMd5tL1TSjod+obrxRSBFi2l0xZYdq+orLckrkpxKSjdnAUDxvGvHNsKkB9Y5EmokjGQkDhRL/UzhQ+FT+ffC/BNOAVCFyr7QcmYbrEfzoi9yRdKwRtAS+kk4eIqUGZVIRr+Rfw/8Ayk4jvBWYJXeIoegzcPoEjYI/yA/yzjUW29JAO9OqJDtDUa0J93RhVh0Ar1PAinPYMQp0X64bXogwFBF27fO+mQw+nar2zis4xckgQ2084+Olb4xWdROYqpYOtcQhwQqoH3bY9fGiHe9CNrifBkkmpYqdcG9DJ7chjXg90mI7Gd2M58bumxeoXZ/y6XJele7V4Im5Ep+Sem25jFplPcnpQzjoOOyKYp8L55N03YzmBPRrLmWLEnBNUJK5VpU6dPBERJT4/ihxfCNMPxQEnVDqCDUFGqzmIxRpj3Tl8TFmRDhfcUGj/H9If9C4mPVa9kt6dlc0eeEpB0E/rUOoWw== engineering@sculpted.io"
    ];
  };

  home-manager.users.quinnherden = {
    home.packages = [ pkgs.atool pkgs.httpie ];
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
        PATH = "$PATH:$HOME/.local/bin/scripts";
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
        vim = "nvmim";
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
    
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.11";
  };

}