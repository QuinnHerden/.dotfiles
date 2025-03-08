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

  system.defaults.smb = {
    # hostname
    NetBIOSName = "mac-papi";
    ServerDescription = "mac-papi";
  };

  security.pki.certificateFiles = [];

  time.timeZone = "America/New_York";

  ids.gids.nixbld = 350;

  driverUser = {
    enable = true;
    userName = "quinnherden";
  };


}