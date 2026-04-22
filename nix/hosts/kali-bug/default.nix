{
  lib,
  config,
  pkgs,
  ...
}:

{

  home.username = "quinnherden";
  home.homeDirectory = "/home/quinnherden";

  standaloneCommonPackages.enable = true;
  standaloneLinuxPackages.enable = true;

}
