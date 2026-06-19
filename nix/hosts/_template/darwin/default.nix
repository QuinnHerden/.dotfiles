# Generic nix-darwin template. To add a machine:
#   1. Copy this directory to hosts/<name>/.
#   2. Set hostname.name, user.name, time.timeZone, and the package toggles.
#   3. Add an entry under hosts.darwin in flake.nix.
_:

{
  system.stateVersion = 4; # $ darwin-rebuild changelog
  nixpkgs.hostPlatform = "aarch64-darwin";

  time.timeZone = "UTC"; # change to your timezone, e.g. "America/New_York"

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
