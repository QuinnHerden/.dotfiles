{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./bluetooth.nix
    ./i3.nix
    ./keyd.nix
    ./libinput.nix
    ./redshift.nix
  ];

}
