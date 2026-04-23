{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ../content/base.nix
    ./commsCommonPackages.nix
    ./commsLinuxPackages.nix
    ./commsLinuxX86Packages.nix
    ./devCommonPackages.nix
    ./devLinuxPackages.nix
    ./devLinuxX86Packages.nix
    ./experimentalCommonPackages.nix
    ./experimentalLinuxPackages.nix
    ./experimentalLinuxX86Packages.nix
    ./extraCommonPackages.nix
    ./extraLinuxPackages.nix
    ./extraLinuxX86Packages.nix
    ./infraCommonPackages.nix
    ./infraLinuxPackages.nix
    ./infraLinuxX86Packages.nix
    ./opsCommonPackages.nix
    ./opsLinuxPackages.nix
    ./opsLinuxX86Packages.nix
    ./secCommonPackages.nix
    ./secLinuxPackages.nix
    ./secLinuxX86Packages.nix
  ];

}
