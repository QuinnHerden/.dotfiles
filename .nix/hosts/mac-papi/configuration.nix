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

  ids.gids.nixbld = 350;

  driverUser = {
    enable = true;
    userName = "quinnherden";
  };

}