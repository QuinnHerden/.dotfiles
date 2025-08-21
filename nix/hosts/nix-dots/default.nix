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
  vpn-us-ga-285.enable = true;

  bluetooth.enable = true;

  keyd.enable = true;
  libinput.enable = true;

  i3.enable = true;
  redshift.enable = true;

  docker.enable = true;

  linuxPackages.enable = true;

  #######################################
  # fix touchpad error:
  # "elan_i2c invalid report id data (1)"

  boot.extraModprobeConfig = ''
    blacklist elan_i2c
  '';
  #######################################

}

