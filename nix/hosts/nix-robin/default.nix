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

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];

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

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.keyd = {
    enable = true;

    keyboards = {
      default = {
        ids = [ "*" ];
        settings.main = {
          "rightalt+h" = "left";
          "rightalt+j" = "up";
          "rightalt+k" = "down";
          "rightalt+l" = "right";
          
          "capslock" = "overload(control, capslock)";

          "leftctrl+[" = "esc";
        };
      };
    };
  };

  services.libinput = {
    enable = true;

    touchpad = {
      accelSpeed = "0.5";

      naturalScrolling = true;
      scrollMethod = "twofinger";

      tapping = true; # tap to click
    };

    mouse = {
      accelSpeed = "0.5";

      naturalScrolling = true;
    };
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

