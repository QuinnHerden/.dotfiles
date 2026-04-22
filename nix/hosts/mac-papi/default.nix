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

  devCommonPackages.enable = true;
  opsCommonPackages.enable = true;
  devDarwinPackages.enable = true;
  opsDarwinPackages.enable = true;
  experimentalDarwinPackages.enable = true;

}
