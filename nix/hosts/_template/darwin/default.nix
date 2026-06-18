# Generic nix-darwin template. To add a machine:
#   1. Copy this directory to hosts/<name>/.
#   2. Set hostname.name and the package-category toggles below.
#   3. Add an entry under hosts.darwin in flake.nix.
# Note: the user is still quinnherden (system.primaryUser in darwinSystem.nix);
# full username parameterization is a tracked follow-up to #148.
{ pkgs, ... }:

{
  system.stateVersion = 4; # $ darwin-rebuild changelog
  nixpkgs.hostPlatform = "aarch64-darwin";

  hostname = {
    enable = true;
    name = "template-darwin";
  };

  users.users.quinnherden = {
    name = "quinnherden";
    home = "/Users/quinnherden";

    shell = pkgs.zsh;
  };

  commonBaseHome = {
    enable = true;
    name = "quinnherden";
  };
  darwinBaseHome = {
    enable = true;
    name = "quinnherden";
  };

  ############
  # packages #
  ############
  opsPackages.enable = true;
}
