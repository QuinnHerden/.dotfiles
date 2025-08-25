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
  aarch64-linuxSystem.enable = true;

  hostname = {
    enable = true;
    name = "nix-bonko";
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

  keyd.enable = true;
  libinput.enable = true;

  docker.enable = true;

  ################

  i3.enable = false;
  redshift.enable = false;

  commonPackages.enable = false;
  linuxPackages.enable = false;

  ################

  programs.zsh.enable = true;

}

