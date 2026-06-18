# Generic nix-darwin template. To add a machine:
#   1. Copy this directory to hosts/<name>/.
#   2. Set hostname.name, user.name, and the package-category toggles below.
#   3. Add an entry under hosts.darwin in flake.nix.
_:

{
  system.stateVersion = 4; # $ darwin-rebuild changelog
  nixpkgs.hostPlatform = "aarch64-darwin";

  hostname = {
    enable = true;
    name = "template-darwin";
  };

  user = {
    enable = true;
    name = "user";
  };

  commonBaseHome.enable = true;
  darwinBaseHome.enable = true;

  ############
  # packages #
  ############
  opsPackages.enable = true;
}
