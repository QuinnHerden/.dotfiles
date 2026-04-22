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

  devCommonPackages.enable = true;
  devLinuxPackages.enable = true;
  secCommonPackages.enable = true;
  secLinuxPackages.enable = true;

}
