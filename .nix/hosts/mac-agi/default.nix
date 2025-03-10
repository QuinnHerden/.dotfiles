{
  ...
}:

{

  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
  ];
  system.stateVersion = 4; # $ darwin-rebuild changelog
  nixpkgs.hostPlatform = "aarch64-darwin";

  hostname = {
    enable = true;
    name = "mac-agi";
  };

  users.users.quinnherden = {
    name = "quinnherden";
    home = "/Users/quinnherden";
    shell = pkgs.zsh;
  };

  baseHome = {
    enable = true;
    name = "quinnherden";
  };
  
  darwinPackages.enable = true;
  baseBrews.enable = true;
  extraBrews.enable = false;
  experimentalBrews.enable = false;
  
}