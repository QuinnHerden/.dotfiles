{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ../content/base.nix
    ./devCommonPackages.nix
    ./opsCommonPackages.nix
    ./secCommonPackages.nix
    ./devLinuxPackages.nix
    ./opsLinuxPackages.nix
    ./secLinuxPackages.nix
    ./opsCommonX86Packages.nix
    ./opsLinuxX86Packages.nix
  ];

}
