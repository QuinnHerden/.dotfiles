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
}

