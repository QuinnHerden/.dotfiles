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
        settings = {
          main = {
            "capslock" = "overload(layer(escape), capslock)";
            "leftalt" = "layer(meta-mac)";
            "rightalt" = "layer(meta-vim)";
            "control" = "layer(escape)";
          };
          
          "meta-mac" = {
            # Copy
            "c" = "C-insert";
            # Paste
            "v" = "S-insert";
            # Cut
            "x" = "S-delete";

            # Move cursor to beginning of line
            "left" = "home";
            # Move cursor to end of Line
            "right" = "end";
          };
          
          "meta-vim" = {
            "h" = "left";
            "j" = "up";
            "k" = "down";
            "l" = "right";
          };

          "escape:C" = {
            "[" = "esc";
          };

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

