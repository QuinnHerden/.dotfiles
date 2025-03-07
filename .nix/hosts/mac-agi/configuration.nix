{
  pkgs,
  ...
}:

{
  # Docs: https://daiderd.com/nix-darwin/manual/index.html

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
  
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  # If you're on an Intel system, replace with "x86_64-darwin"
  nixpkgs.hostPlatform = "x86_64-darwin";
  
  darwinPackages.enable = true;

  driverUser = {
    enable = true;
    userName = "quinnherden";
  };

  # Set the configured group ID to match the actual value
  # Possible cause: trying a new Nix installation with a pre-existing installation
  ids.gids.nixbld = 350;

}