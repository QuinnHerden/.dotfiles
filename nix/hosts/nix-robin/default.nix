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

  quinnherdenUser.enable = true;
 
  commonBaseHome = {
    enable = true;
    name = "quinnherden";
  };
  nixosBaseHome = {
    enable = true;
    name = "quinnherden";
  };

  linuxPackages.enable = true;

  ### things I need to extract into modules lie below ###

  networking.networkmanager.enable = true;

  openssh.enable = true;

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
            "leftshift" = "overload(shift, capslock)";
            "capslock" = "layer(control)";

            "leftcontrol" = "layer(meta)";
            "meta" = "layer(alt)";
            "leftalt" = "layer(control)";

            "rightalt" = "layer(altgr)";
          };

          # default control layer
          "control" = {
            "[" = "esc";
          };

          # default right alt layer
          "altgr" = {
            "h" = "left";
            "j" = "down";
            "k" = "up";
            "l" = "right";
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

      naturalScrolling = false;
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
      i3 = {
        enable = true;

        extraSessionCommands = ''
          xrandr --output DP-1 --rotate right --left-of eDP-1;
        '';
      };
    };
  };

  services.displayManager = {
    defaultSession = "none+i3";
  };

  location.provider = "geoclue2";

  services.redshift = {
    enable = true;
    brightness = {
      day = "1";
      night = "1";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  virtualisation.docker = {
    enable = true;
  };

  ### VPN ###

  networking.wg-quick.interfaces = let
    # [Interface] > PrivateKey
    int_private_key_file = "/etc/nix-robin-pvpn.key";

    # [Interface] > Address
    int_cidr_ipv4 = "10.2.0.2/32";

    # [Peer] > PublicKey
    peer_public_key = "vsquyHHSbv76cOqCMZCREGur05Mp5XM0lbCAzrGDs2w=";

    # [Peer] > AllowedIPs
    peer_allowed_cidr_ipv4 = "0.0.0.0/0";
    peer_allowed_cidr_ipv6 = "::/0";

    # [Peer] > Endpoint:port
    peer_ipv4 = "149.22.94.86";
    peer_port = 51820;

  in {
    wg0 = {
      address = [
        int_cidr_ipv4
      ];

      listenPort = peer_port;

      privateKeyFile = int_private_key_file;

      peers = [
        {
          allowedIPs = [
            peer_allowed_cidr_ipv4
            peer_allowed_cidr_ipv6
          ];
          publicKey = peer_public_key;
          endpoint = "${peer_ipv4}:${toString(peer_port)}";
          persistentKeepalive = 25;
        }
      ];
    };
  };

}

