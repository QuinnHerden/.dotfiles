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
  x86_64-linuxSystem.enable = true;

  hostname = {
    enable = true;
    name = "nix-dots";
  };

  commonBaseHome = {
    enable = true;
    name = "quinnherden";
  };
  linuxBaseHome = {
    enable = true;
    name = "quinnherden";
  };

  quinnherdenUser.enable = true;

  pam.enable = true;

  wifi.enable = true;
  openssh.enable = true;
  services.tailscale.enable = true;

  bluetooth.enable = true;

  keyd.enable = true;
  libinput.enable = true;

  i3.enable = true;
  redshift.enable = true;

  docker.enable = true;

  ############
  # packages #
  ############
  opsPackages.enable = true;
  devPackages.enable = true;
  infraPackages.enable = true;
  secPackages.enable = true;
  commsPackages.enable = true;
  extraPackages.enable = true;

}
