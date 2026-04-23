{
  lib,
  config,
  pkgs,
  ...
}:

{

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

}
