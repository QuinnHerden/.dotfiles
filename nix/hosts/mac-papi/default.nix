{ pkgs, ... }:

{
  system.stateVersion = 4; # $ darwin-rebuild changelog
  nixpkgs.hostPlatform = "aarch64-darwin";

  time.timeZone = "America/New_York";

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

  # infra's heavy set is linux-only in mkPackageModule; keep it on the Mac.
  environment.systemPackages = with pkgs; [
    awscli2
    packer
  ];

}
