{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./networking
    ./packages
    ./services
    ./system
    ./users
  ];

}
