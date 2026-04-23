{
  pkgs,
  ...
}:

{
  system.stateVersion = 4; # $ darwin-rebuild changelog
  nixpkgs.hostPlatform = "aarch64-darwin";

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

  ############
  # packages #
  ############
  opsCommonPackages.enable = true;
  opsDarwinPackages.enable = true;

  devCommonPackages.enable = true;
  devDarwinPackages.enable = true;

  infraCommonPackages.enable = true;
  infraDarwinPackages.enable = true;

  secCommonPackages.enable = true;
  secDarwinPackages.enable = true;

  commsCommonPackages.enable = true;
  commsDarwinPackages.enable = true;

  extraCommonPackages.enable = true;
  extraDarwinPackages.enable = true;

  experimentalCommonPackages.enable = true;
  experimentalDarwinPackages.enable = true;

}
