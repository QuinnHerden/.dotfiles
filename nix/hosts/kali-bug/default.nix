{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [ ../../modules/home/content/linux.nix ];

  home.username = "quinnherden";
  home.homeDirectory = "/home/quinnherden";

  ############
  # packages #
  ############
  opsPackages.enable = true;
  devPackages.enable = true;
  secPackages.enable = true;

}
