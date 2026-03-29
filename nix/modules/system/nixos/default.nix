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
    ./security
    ./services
    ./users
    ./vpns
  ];

}
