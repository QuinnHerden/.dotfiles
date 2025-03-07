{
  lib,
  config,
  pkgs,
  ...
}:

{

  imports = [
    ./auths
    ./fonts
    ./packages
    ./users
  ];

}