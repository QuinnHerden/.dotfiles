{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ../content/base.nix
    ./commonPackages.nix
    ./linuxPackages.nix
    ./x86CommonPackages.nix
    ./x86LinuxPackages.nix
  ];

}
