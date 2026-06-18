# Generic standalone home-manager template (no NixOS/nix-darwin system layer).
# To add a target:
#   1. Copy this directory to hosts/<name>/.
#   2. Set home.username and home.homeDirectory.
#   3. Add an entry under hosts.home in flake.nix (with the right system).
# The home modules are username-parameterized, so this template is fully generic.
_:

{
  imports = [ ../../../modules/home/content/linux.nix ];

  home.username = "template";
  home.homeDirectory = "/home/template";

  ############
  # packages #
  ############
  opsPackages.enable = true;
}
