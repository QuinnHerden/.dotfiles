{
  pkgs,
  ...
}:

{
  system.stateVersion = 4; # $ darwin-rebuild changelog
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
  
  hostname = {
    enable = true;
    name = "mac-papi";
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

  commonPackages.enable = true;
  darwinPackages.enable = true;
  baseBrews.enable = true;
  extraBrews.enable = true;
  experimentalBrews.enable = true;

  commonSystem.enable = true;

}
