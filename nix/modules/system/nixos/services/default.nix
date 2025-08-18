{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./bluetooth.nix
    ./keyd.nix
    ./libinput.nix
    ./i3.nix
  ];

}
