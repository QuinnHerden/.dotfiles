_:

{
  system.stateVersion = 4; # $ darwin-rebuild changelog
  nixpkgs.hostPlatform = "aarch64-darwin";

  hostname = {
    enable = true;
    name = "mac-papi";
  };

  user = {
    enable = true;
    name = "quinnherden";
  };

  commonBaseHome.enable = true;
  darwinBaseHome.enable = true;

  ############
  # packages #
  ############
  opsPackages.enable = true;
  devPackages.enable = true;
  infraPackages.enable = true;
  secPackages.enable = true;
  commsPackages.enable = true;
  extraPackages.enable = true;
  experimentalPackages.enable = true;

}
