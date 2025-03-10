{
  pkgs,
  inputs,
  config,
  ...
}:

{
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
  system.stateVersion = 4; # $ darwin-rebuild changelog
  nixpkgs.hostPlatform = "aarch64-darwin";

  hostname = {
    enable = true;
    name = "mac-papi";
  };

  users.users.quinnherden = {
    name = "quinnherden";
    home = "/Users/quinnherden";
  };

  baseHome = {
    enable = true;
    name = "quinnherden";
  };

  darwinPackages.enable = true;
  baseBrews.enable = true;
  extraBrews.enable = true;
  experimentalBrews.enable = true;
}