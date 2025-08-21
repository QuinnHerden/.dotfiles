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
    name = "nix-dots";
  };

  commonBaseHome = {
    enable = true;
    name = "quinnherden";
  };
  nixosBaseHome = {
    enable = true;
    name = "quinnherden";
  };

  quinnherdenUser.enable = true;

  wifi.enable = true;
  openssh.enable = true;
  vpn-us-ga-285.enable = false;

  bluetooth.enable = true;

  keyd.enable = true;
  libinput.enable = true;

  i3.enable = true;
  redshift.enable = true;

  docker.enable = true;

  linuxPackages.enable = true;

}

