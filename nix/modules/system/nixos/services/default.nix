{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./bluetooth.nix
    ./docker.nix
    ./i3.nix
    ./keyd.nix
    ./libinput.nix
    ./redshift.nix
  ];

}
