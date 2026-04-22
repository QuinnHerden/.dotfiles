{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [];

  system.stateVersion = "24.11";
  x86_64-linuxSystem.enable = true;

  hostname = {
    enable = true;
    name = "kali-bug";
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

  #pam.enable = true;

  #wifi.enable = true;
  #openssh.enable = true;
  #services.tailscale.enable = true;

  #bluetooth.enable = true;

  #keyd.enable = true;
  #libinput.enable = true;

  #i3.enable = true;
  #redshift.enable = true;

  #docker.enable = true;

  commonPackages.enable = true;
  linuxPackages.enable = true;

}

