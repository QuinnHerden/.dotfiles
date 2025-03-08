{
  pkgs,
  ...
}:

{

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
  
  system.stateVersion = 4; # $ darwin-rebuild changelog
  nixpkgs.hostPlatform = "aarch64-darwin";

  darwinPackages.enable = true;
  
  hostname = {
    enable = true;
    name = "mac-agi";
  };

  ids.gids.nixbld = 350;

  driverUser = {
    enable = true;
    userName = "quinnherden";
  };

}