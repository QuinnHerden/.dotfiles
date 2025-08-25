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

  i3.enable = true;
  redshift.enable = true;

  docker.enable = true;

  ################

  commonPackages.enable = false;
  linuxPackages.enable = false;

  commonSystem.enable = false;

  programs.zsh.enable = true;

}

