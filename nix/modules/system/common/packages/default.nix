{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./devCommonPackages.nix
    ./opsCommonPackages.nix
    ./secCommonPackages.nix
  ];

}
