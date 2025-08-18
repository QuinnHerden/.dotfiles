{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./hostname.nix
    ./openssh.nix
    ./wifi.nix
  ];

}
