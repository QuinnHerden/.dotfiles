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

  standaloneCommonPackages.enable = true;
  standaloneLinuxPackages.enable = true;

}
