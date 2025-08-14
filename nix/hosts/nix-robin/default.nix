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

  services.xserver = {
    enable = true;

    xkb.options = "ctrl:swapcaps";

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3.enable = true;
  };

  services.displayManager = {
    defaultSession = "none+i3";
  };
}

