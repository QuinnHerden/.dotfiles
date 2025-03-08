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
  
  baseBrews.enable = true;
  extraBrews.enable = true;
  experimentalBrews.enable = true;
  
  hostname = {
    enable = true;
    name = "mac-papi";
  };

  ids.gids.nixbld = 350;

  driverUser = {
    enable = true;
    userName = "quinnherden";
  };


}