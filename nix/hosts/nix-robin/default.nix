{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ 
    ./hardware-configuration.nix
  ];
  system.stateVersion = "24.11";
  
  hostname = {
    enable = true;
    name = "nix-robin";
  };
  
  openssh.enable = true;

  quinnherdenUser.enable = true;
  
  baseHome = {
    enable = true;
    name = "quinnherden";
  };

  linuxPackages.enable = true;

  networking.networkmanager.enable = true;

  services.libinput = {
    enable = true;
  };

  #######################################
  # fix touchpad error:
  # "elan_i2c invalid report id data (1)"

  boot.extraModprobeConfig = ''
    blacklist elan_i2c
  '';
  
  #######################################

  services.xserver = {
    enable = true;

    xkb.options = "ctrl:swapcaps"; # swap ctrl and caps lock
    
    desktopManager = {
      xterm.enable = false;
    };

    windowManager = {
      i3.enable = true;
    };
  };
  
  services.displayManager = {
    defaultSession = "none+i3";
  };
}

