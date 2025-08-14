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

  environment.systemPackages = with pkgs; [
    xf86-input-libinput
  ];

  services.xserver = {
    enable = true;

    xkb.options = "ctrl:swapcaps";

    config = ''
      Section "InputClass"
          Identifier "ELAN Touchpad"
          MatchIsTouchpad "on"
          Driver "libinput"
          Option "Tapping" "on"
          Option "NaturalScrolling" "true"
          Option "ScrollMethod" "twofinger"
      EndSection
    '';

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

