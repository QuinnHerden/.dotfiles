{
  lib,
  config,
  pkgs,
  ...
}:

{

  home.username = "dev";
  home.homeDirectory = "/home/dev";

  devPackages.enable = true;
  opsPackages.enable = true;
  opsPackages.enableGui = false;
  opsPackages.enableHeavy = false;

}
