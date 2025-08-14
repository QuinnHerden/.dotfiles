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

  services.libinput.enable = true;

  services.displayManager = {
    defaultSession = "none+i3";
  };

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    windowManager.i3.enable = true;
  };
}

