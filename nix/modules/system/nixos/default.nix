{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./boot
    ./networking
    ./packages
    ./services
    ./users
    ./vpns
  ];

}
